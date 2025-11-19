<#
.SYNOPSIS
Thin wrapper around docker/podman compose to keep environments consistent.

.DESCRIPTION
Reads .env.<env> to determine compose project/network names, runs compose up/down/logs,
and ensures the custom services network is removed on teardown.
#>
[CmdletBinding()]
param(
    [Parameter()]
    [ValidatePattern("^[a-zA-Z0-9_-]+$")]
    [string]$Environment = "dev",

    [Parameter()]
    [ValidateSet("up", "down", "logs", "ps")]
    [string]$Action = "up",

    [switch]$Rebuild
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-ContainerCli {
    $podman = Get-Command podman -ErrorAction SilentlyContinue
    $docker = Get-Command docker -ErrorAction SilentlyContinue

    if ($podman) { return @{ Name = "podman"; Command = $podman.Source } }
    if ($docker) { return @{ Name = "docker"; Command = $docker.Source } }
    throw "Neither Docker nor Podman CLI was found in PATH."
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
        if (-not $IgnoreErrors) { throw }
    }
}

function Get-NetworkSubnets {
    param(
        [hashtable]$Cli,
        [string]$NetworkName
    )
    $inspect = Invoke-ContainerCommand -Cli $Cli -Args @("network", "inspect", $NetworkName) -IgnoreErrors
    if (-not $inspect) { return @() }
    $json = $inspect | ConvertFrom-Json
    $subnets = @()
    foreach ($entry in $json) {
        if ($entry.PSObject.Properties.Name -contains "IPAM" -and $entry.IPAM -and $entry.IPAM.Config) {
            foreach ($cfg in $entry.IPAM.Config) {
                if ($cfg.Subnet) { $subnets += $cfg.Subnet }
            }
        }
        elseif ($entry.PSObject.Properties.Name -contains "Subnets" -and $entry.Subnets) {
            foreach ($cfg in $entry.Subnets) {
                if ($cfg.Subnet) { $subnets += $cfg.Subnet }
            }
        }
    }
    return $subnets
}

function Ensure-NetworkSubnet {
    param(
        [hashtable]$Cli,
        [string]$NetworkName,
        [string]$ExpectedSubnet
    )
    if (-not $NetworkName -or -not $ExpectedSubnet) { return }
    $subnets = Get-NetworkSubnets -Cli $Cli -NetworkName $NetworkName
    if (-not $subnets -or $subnets -contains $ExpectedSubnet) {
        return
    }
    Write-Host "Existing network '$NetworkName' uses subnet(s): $($subnets -join ', '). Recreating to apply $ExpectedSubnet." -ForegroundColor Yellow
    try {
        Invoke-ContainerCommand -Cli $Cli -Args @("network", "rm", $NetworkName)
    }
    catch {
        throw "Failed to remove out-of-date network '$NetworkName'. Run Manage-Stack.ps1 -Action down (or stop containers) and retry. $_"
    }
}

function Read-EnvFile {
    param([string]$Path)
    $table = @{}
    foreach ($line in (Get-Content $Path -ErrorAction Stop)) {
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

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$originalLocation = Get-Location
Set-Location $repoRoot

$envFile = ".env.$Environment"
try {
    if (-not (Test-Path $envFile)) {
        throw "$envFile not found. Run Initialize-Environment.ps1 first."
    }

    $envTable = Read-EnvFile -Path $envFile
    $projectName = $envTable["COMPOSE_PROJECT_NAME"]
    if (-not $projectName) { $projectName = "projectseed" }
    $networkName = $envTable["SERVICES_NETWORK_NAME"]
    if (-not $networkName) { $networkName = "projectseed_services" }

    $profileMap = @{
        dev = "dev"
        staging = "prod"
        prod = "prod"
    }
    $composeProfile = $profileMap[$Environment.ToLower()]
    if (-not $composeProfile) { $composeProfile = "prod" }

    $cli = Get-ContainerCli
    $expectedSubnet = $envTable["SERVICES_SUBNET"]

    $commonCommandArgs = @("compose", "-f", "docker-compose.yml", "--env-file", $envFile, "--profile", $composeProfile, "-p", $projectName)

switch ($Action) {
    "up" {
        Ensure-NetworkSubnet -Cli $cli -NetworkName $networkName -ExpectedSubnet $expectedSubnet
        $commandArgs = $commonCommandArgs + @("up", "-d")
        if ($Rebuild) {
            $commandArgs += "--build"
        }
        Invoke-ContainerCommand -Cli $cli -Args $commandArgs
    }
    "down" {
        $commandArgs = $commonCommandArgs + @("down", "--volumes", "--remove-orphans")
        Invoke-ContainerCommand -Cli $cli -Args $commandArgs
        Invoke-ContainerCommand -Cli $cli -Args @("network", "rm", $networkName) -IgnoreErrors
    }
    "logs" {
        $commandArgs = $commonCommandArgs + @("logs", "-f")
        Invoke-ContainerCommand -Cli $cli -Args $commandArgs
    }
    "ps" {
        $commandArgs = $commonCommandArgs + @("ps")
        Invoke-ContainerCommand -Cli $cli -Args $commandArgs
    }
}
}
finally {
    Set-Location $originalLocation
}
