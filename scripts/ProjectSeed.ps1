<#
.SYNOPSIS
Interactive entry point for the ProjectSeed helper scripts.

.DESCRIPTION
Provides a simple menu-driven interface for initializing environments and managing the compose stack
without having to remember each script/flag combo.
#>
[CmdletBinding()]
param(
    [switch]$QuickstartDev
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

function Read-MenuSelection {
    param(
        [Parameter(Mandatory = $true)][string]$Prompt,
        [string[]]$ValidValues
    )

    while ($true) {
        $value = Read-Host $Prompt
        if (-not $ValidValues -or $ValidValues -contains $value) {
            return $value
        }
        Write-Host "Invalid choice. Valid options: $($ValidValues -join ', ')" -ForegroundColor Yellow
    }
}

function Read-Environment {
    $env = Read-Host "Target environment [dev]"
    if (-not $env) { $env = "dev" }
    return $env
}

function Read-YesNo {
    param([string]$Prompt, [bool]$Default = $false)
    $suffix = if ($Default) { "[Y/n]" } else { "[y/N]" }
    while ($true) {
        $response = Read-Host "$Prompt $suffix"
        if (-not $response) { return $Default }
        switch ($response.ToLower()) {
            "y" { return $true }
            "yes" { return $true }
            "n" { return $false }
            "no" { return $false }
            default { Write-Host "Please answer y or n." -ForegroundColor Yellow }
        }
    }
}

function Invoke-EnvironmentInitialization {
    $environment = Read-Environment
    $regen = Read-YesNo -Prompt "Regenerate secrets" -Default:$false
    $initializerArgs = @("-File", (Join-Path $scriptRoot "Initialize-Environment.ps1"), "-Environment", $environment)
    if ($regen) { $initializerArgs += "-RegenerateSecrets" }
    Write-Host "`nRunning Initialize-Environment.ps1 ..." -ForegroundColor Cyan
    pwsh @initializerArgs
}

function Invoke-StackManager {
    $environment = Read-Environment
    $action = Read-MenuSelection -Prompt "Choose action (up/down/logs/ps)" -ValidValues @("up", "down", "logs", "ps")
    $rebuild = $false
    if ($action -eq "up") {
        $rebuild = Read-YesNo -Prompt "Force rebuild images" -Default:$false
    }
    $stackArgs = @("-File", (Join-Path $scriptRoot "Manage-Stack.ps1"), "-Environment", $environment, "-Action", $action)
    if ($rebuild) { $stackArgs += "-Rebuild" }
    Write-Host "`nRunning Manage-Stack.ps1 ..." -ForegroundColor Cyan
    pwsh @stackArgs
}

function Invoke-QuickstartDev {
    Write-Host "Running dev quickstart..." -ForegroundColor Cyan
    $initArgs = @("-File", (Join-Path $scriptRoot "Initialize-Environment.ps1"), "-Environment", "dev")
    pwsh @initArgs
    $manageArgs = @("-File", (Join-Path $scriptRoot "Manage-Stack.ps1"), "-Environment", "dev", "-Action", "up")
    pwsh @manageArgs
    Write-Host "Dev environment is running on http://localhost:5173 (app-dev) and Postgres/Redis on the internal network." -ForegroundColor Green
    Write-Host "Use '-Action down' or the interactive menu to stop the stack when finished." -ForegroundColor Green
}

if ($QuickstartDev) {
    Invoke-QuickstartDev
    return
}

function Show-Menu {
    Write-Host ""
    Write-Host "ProjectSeed helper" -ForegroundColor Cyan
    Write-Host "1) Initialize / update environment files"
    Write-Host "2) Manage compose stack (up/down/logs/ps)"
    Write-Host "3) Exit"
}

while ($true) {
    Show-Menu
    $choice = Read-MenuSelection -Prompt "Select option [1-3]" -ValidValues @("1", "2", "3")
    switch ($choice) {
        "1" { Invoke-EnvironmentInitialization }
        "2" { Invoke-StackManager }
        "3" {
            Write-Host "Bye!" -ForegroundColor Green
            return
        }
    }
}
