<#
.SYNOPSIS
Generates per-environment configuration, secrets, and database/bootstrap files.

.DESCRIPTION
Takes the template files under /templates, replaces placeholders, and writes
environment-specific files plus a symlink that points app/.env to .env.dev for pnpm dev.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidatePattern("^[a-zA-Z0-9_-]+$")]
    [string]$Environment = "dev",

    [switch]$RegenerateSecrets
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-ContainerCli {
    $podman = Get-Command podman -ErrorAction SilentlyContinue
    $docker = Get-Command docker -ErrorAction SilentlyContinue

    if ($podman) {
        return @{ Name = "podman"; Command = $podman.Source }
    }
    if ($docker) {
        return @{ Name = "docker"; Command = $docker.Source }
    }
    throw "Neither Docker nor Podman CLI was found in PATH. Install one of them first."
}

function Invoke-ContainerCommand {
    param(
        [Parameter(Mandatory = $true)][hashtable]$Cli,
        [Parameter(Mandatory = $true)][string[]]$Args,
        [switch]$IgnoreErrors
    )

    try {
        & $Cli.Command @Args
    }
    catch {
        if (-not $IgnoreErrors) {
            throw
        }
        return $null
    }
}

function Get-ExistingSubnets {
    param([hashtable]$Cli)
    $subnets = [System.Collections.Generic.HashSet[string]]::new()
    $names = Invoke-ContainerCommand -Cli $Cli -Args @("network", "ls", "--format", "{{.Name}}") -IgnoreErrors
    if (-not $names) {
        return $subnets
    }

    foreach ($name in ($names -split "`n" | Where-Object { $_.Trim() })) {
        $inspect = Invoke-ContainerCommand -Cli $Cli -Args @("network", "inspect", $name) -IgnoreErrors
        if (-not $inspect) { continue }
        $json = $inspect | ConvertFrom-Json
        foreach ($entry in $json) {
            $hasIpam = $entry.PSObject.Properties.Name -contains "IPAM"
            if ($hasIpam -and $entry.IPAM -and $entry.IPAM.Config) {
                foreach ($cfg in $entry.IPAM.Config) {
                    if ($cfg.Subnet) {
                        [void]$subnets.Add($cfg.Subnet)
                    }
                }
            }
            elseif ($entry.PSObject.Properties.Name -contains "Subnets") {
                foreach ($cfg in $entry.Subnets) {
                    if ($cfg.Subnet) {
                        [void]$subnets.Add($cfg.Subnet)
                    }
                }
            }
        }
    }

    return $subnets
}

function Get-AvailableSubnet {
    param(
        [System.Collections.Generic.HashSet[string]]$ExistingSubnets
    )

    $candidates = @(
        "172.28.0.0/24",
        "172.29.0.0/24",
        "172.30.0.0/24",
        "172.31.0.0/24"
    )

    foreach ($candidate in $candidates) {
        if (-not $ExistingSubnets.Contains($candidate)) {
            return $candidate
        }
    }

    throw "No free 172.28-31.0.0/24 subnet found. Remove an unused network or extend the candidate list."
}

function Get-GatewayFromSubnet {
    param([string]$Subnet)
    $parts = $Subnet.Split("/")
    $octets = $parts[0].Split(".")
    $octets[3] = "1"
    return $octets -join "."
}

function Get-HostAddressFromSubnet {
    param(
        [string]$Subnet,
        [int]$Offset
    )

    $baseIp = $Subnet.Split("/")[0]
    $ipAddress = [System.Net.IPAddress]::Parse($baseIp)
    $bytes = $ipAddress.GetAddressBytes()
    [Array]::Reverse($bytes)
    $baseValue = [BitConverter]::ToUInt32($bytes, 0)
    $newValue = $baseValue + [uint32]$Offset
    $newBytes = [BitConverter]::GetBytes($newValue)
    [Array]::Reverse($newBytes)
    return ([System.Net.IPAddress]::new($newBytes)).ToString()
}

function Convert-EnvFileToHashtable {
    param([string]$Path)
    $table = @{}
    if (-not (Test-Path $Path)) { return $table }
    foreach ($line in (Get-Content $Path)) {
        if (-not $line -or $line.TrimStart().StartsWith("#") -or -not $line.Contains("=")) {
            continue
        }
        $idx = $line.IndexOf("=")
        $key = $line.Substring(0, $idx).Trim()
        $value = $line.Substring($idx + 1).Trim()
        $table[$key] = $value
    }
    return $table
}

function Get-OrKeepValue {
    param(
        [string]$Key,
        [hashtable]$Existing,
        [scriptblock]$Factory
    )

    if (-not $RegenerateSecrets.IsPresent -and $Existing.ContainsKey($Key) -and $Existing[$Key]) {
        return $Existing[$Key]
    }

    return & $Factory
}

function Get-ConfigValue {
    param(
        [string]$Key,
        [hashtable]$Existing,
        [string]$Default
    )
    if ($Existing.ContainsKey($Key) -and $Existing[$Key]) {
        return $Existing[$Key]
    }
    return $Default
}

function New-RandomSecret {
    param([int]$Length = 40)
    $chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-"
    $builder = [System.Text.StringBuilder]::new()
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    $bytes = New-Object byte[] ($Length)
    $rng.GetBytes($bytes)
    foreach ($byte in $bytes) {
        $char = $chars[$byte % $chars.Length]
        [void]$builder.Append($char)
    }
    return $builder.ToString()
}

function Expand-Template {
    param(
        [string]$TemplatePath,
        [string]$DestinationPath,
        [hashtable]$Values
    )
    if (-not (Test-Path $TemplatePath)) {
        throw "Template not found: $TemplatePath"
    }
    $content = Get-Content $TemplatePath -Raw
    foreach ($key in $Values.Keys) {
        $token = "{{$key}}"
        $content = $content.Replace($token, $Values[$key])
    }
    $destDir = Split-Path $DestinationPath -Parent
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }
    $content | Out-File -FilePath $DestinationPath -Encoding utf8NoBOM
}

function Set-AppEnvSymlink {
    param(
        [string]$EnvironmentName,
        [string]$RepoRoot
    )

    if ($EnvironmentName -ne "dev") {
        return
    }

    $source = Join-Path $RepoRoot ".env.dev"
    $target = Join-Path $RepoRoot "app\\.env"

    if (-not (Test-Path $source)) {
        Write-Warning "Cannot create app/.env symlink because $source is missing."
        return
    }

    if (Test-Path $target) {
        $item = Get-Item $target -Force
        if (-not $item.Attributes.HasFlag([IO.FileAttributes]::ReparsePoint)) {
            $backup = "$target.backup"
            Copy-Item $target $backup -Force
            Remove-Item $target -Force
            Write-Host "Existing app/.env backed up to $backup" -ForegroundColor Yellow
        }
        else {
            Remove-Item $target -Force
        }
    }

    $relativeSource = Resolve-Path $source
    try {
        New-Item -ItemType SymbolicLink -Path $target -Target $relativeSource -Force | Out-Null
        Write-Host "Linked app/.env -> $source" -ForegroundColor Green
    }
    catch {
        Write-Warning "Failed to create symbolic link for app/.env. Run PowerShell as Administrator or enable Developer Mode. $_"
    }
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$templatesRoot = Join-Path $repoRoot "templates"
$envTemplate = Join-Path (Join-Path $templatesRoot "env") ".env.$Environment.template"
if (-not (Test-Path $envTemplate)) {
    $envTemplate = Join-Path (Join-Path $templatesRoot "env") ".env.template"
}
if (-not (Test-Path $envTemplate)) {
    throw "No environment template found at $envTemplate"
}

$targetEnvFile = Join-Path $repoRoot ".env.$Environment"
$existingValues = Convert-EnvFileToHashtable -Path $targetEnvFile

$cli = Get-ContainerCli
Write-Host "Detected container CLI: $($cli.Name)" -ForegroundColor Cyan
$composeFileArgs = @("-f docker-compose.yml")
$existingSubnets = Get-ExistingSubnets -Cli $cli

$subnet = Get-OrKeepValue -Key "SERVICES_SUBNET" -Existing $existingValues -Factory { Get-AvailableSubnet -ExistingSubnets $existingSubnets }
$gateway = Get-OrKeepValue -Key "SERVICES_GATEWAY" -Existing $existingValues -Factory { Get-GatewayFromSubnet -Subnet $subnet }

$environmentMatrix = @{
    dev = @{ NodeEnv = "development"; Profile = "dev"; DevPort = "5173"; ProdPort = "4173"; PublicOrigin = "http://localhost:5173" }
    staging = @{ NodeEnv = "staging"; Profile = "prod"; DevPort = "5173"; ProdPort = "4173"; PublicOrigin = "https://staging.projectseed.local" }
    prod = @{ NodeEnv = "production"; Profile = "prod"; DevPort = "5173"; ProdPort = "4173"; PublicOrigin = "https://app.projectseed.local" }
}

$envInfo = $environmentMatrix[$Environment.ToLower()] 
if (-not $envInfo) {
    $envInfo = @{
        NodeEnv = $Environment.ToLower()
        Profile = "prod"
        DevPort = "5173"
        ProdPort = "4173"
        PublicOrigin = "https://$Environment.projectseed.local"
    }
}

$secretKeys = @(
    "POSTGRES_SUPERUSER_PASSWORD",
    "POSTGRES_APP_PASSWORD",
    "POSTGRES_API_PASSWORD",
    "POSTGRES_READONLY_PASSWORD",
    "POSTGRES_MIGRATIONS_PASSWORD",
    "REDIS_ADMIN_PASSWORD",
    "REDIS_API_PASSWORD",
    "REDIS_READONLY_PASSWORD"
)

$staticDefaults = @{
    POSTGRES_DB = "projectseed"
    POSTGRES_SUPERUSER = "app_owner"
    POSTGRES_APP_USER = "app_runtime"
    POSTGRES_API_USER = "api_worker"
    POSTGRES_READONLY_USER = "app_reader"
    POSTGRES_MIGRATIONS_USER = "app_migrator"
    REDIS_ADMIN_USER = "redis_admin"
    REDIS_API_USER = "redis_api"
    REDIS_READONLY_USER = "redis_readonly"
    SERVICES_NETWORK_NAME = "projectseed_services"
}

$placeholders = @{
    "NODE_ENV" = $envInfo.NodeEnv
    "APP_PROFILE" = $envInfo.Profile
    "APP_DEV_PORT" = $envInfo.DevPort
    "APP_PROD_PORT" = $envInfo.ProdPort
    "PUBLIC_ORIGIN" = $envInfo.PublicOrigin
    "ENVIRONMENT" = $Environment
    "SERVICES_SUBNET" = $subnet
    "SERVICES_GATEWAY" = $gateway
}

$placeholders["NETWORK_REDIS_IP"] = Get-OrKeepValue -Key "NETWORK_REDIS_IP" -Existing $existingValues -Factory { Get-HostAddressFromSubnet -Subnet $subnet -Offset 10 }

foreach ($staticKey in $staticDefaults.Keys) {
    $placeholders[$staticKey] = Get-ConfigValue -Key $staticKey -Existing $existingValues -Default $staticDefaults[$staticKey]
}

foreach ($key in $secretKeys) {
    $placeholders[$key] = Get-OrKeepValue -Key $key -Existing $existingValues -Factory { New-RandomSecret }
}

Expand-Template -TemplatePath $envTemplate -DestinationPath $targetEnvFile -Values $placeholders
Write-Host "Wrote $targetEnvFile" -ForegroundColor Green

$pgEnvDir = Join-Path (Join-Path $repoRoot "infrastructure\\postgres") $Environment
$redisEnvDir = Join-Path (Join-Path $repoRoot "infrastructure\\redis") $Environment

$pgTemplate = Join-Path (Join-Path $templatesRoot "postgres") "init.sql.template"
$redisConfTemplate = Join-Path (Join-Path $templatesRoot "redis") "redis.conf.template"
$redisAclTemplate = Join-Path (Join-Path $templatesRoot "redis") "users.acl.template"
$redisNetworkTemplate = Join-Path (Join-Path $templatesRoot "redis") "network.conf.template"

Expand-Template -TemplatePath $pgTemplate -DestinationPath (Join-Path $pgEnvDir "init.sql") -Values $placeholders
Expand-Template -TemplatePath $redisConfTemplate -DestinationPath (Join-Path $redisEnvDir "redis.conf") -Values $placeholders
Expand-Template -TemplatePath $redisAclTemplate -DestinationPath (Join-Path $redisEnvDir "users.acl") -Values $placeholders
Expand-Template -TemplatePath $redisNetworkTemplate -DestinationPath (Join-Path $redisEnvDir "network.conf") -Values $placeholders
Write-Host "Generated postgres and redis bootstrap files for $Environment" -ForegroundColor Green

if (-not $existingValues.ContainsKey("SERVICES_SUBNET")) {
    Write-Host "Reserved subnet $subnet for services network." -ForegroundColor Green
}

Set-AppEnvSymlink -EnvironmentName $Environment.ToLower() -RepoRoot $repoRoot

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
$composeNextCommand = "$($cli.Name) compose"
foreach ($arg in $composeFileArgs) {
    $composeNextCommand += " $arg"
}
$composeNextCommand += " --env-file .env.$Environment --profile $($envInfo.Profile) up -d"
Write-Host "  $composeNextCommand" -ForegroundColor Cyan
if ($cli.Name -eq "docker") {
    $networkForMessage = $placeholders["SERVICES_NETWORK_NAME"]
    if (-not $networkForMessage) { $networkForMessage = "projectseed_services" }
    Write-Host "  (If Docker reports a static IP subnet mismatch, run '$($cli.Name) network rm $networkForMessage' and retry or use Manage-Stack.ps1 -Action up.)" -ForegroundColor Yellow
}
