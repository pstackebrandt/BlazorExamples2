# Deploys the Blazor application to Azure Web App.
#
# Usage:
# Run this script from the root directory, where the .sln file is located.
#   pwsh ./scripts/deployment/deploy.ps1
#
# - DryRun shows commands without executing them.
#   pwsh ./scripts/deployment/deploy.ps1 -DryRun
#
# Before running, ensure you have:
# 1. Copied deploy.env.example to deploy.env and filled in your values.
# 2. Logged in to Azure with the Azure CLI (`az login`).
# 3. Set the correct Azure subscription (`az account set --subscription <your-subscription-id>`).

param(
    [switch]$DryRun
)

# --- Load Deployment Environment Variables from deploy.env ---
$envFile = "$PSScriptRoot/deploy.env"
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^(.*?)=(.*)$') {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()
            Set-Variable -Name $name -Value $value -Scope Script
        }
    }
} else {
    Write-Error "Environment file $envFile not found."
    exit 1
}

$ResourceGroupName = $RESOURCE_GROUP_NAME
$WebAppName = $WEB_APP_NAME

Write-Host "`n--- Deployment Variables ---"
Write-Host "Resource Group: $ResourceGroupName"
Write-Host "Web App Name:   $WebAppName"
Write-Host "---------------------------`n"

# --- Script Configuration ---
# The output directory for the published files.
$publishDir = "./bin/Publish"
# The path for the deployment zip file.
$zipPath = "./blazor-app.zip"

# --- Helper Functions ---
# Safely executes a command, supporting -DryRun mode.
function Invoke-CommandSafe {
    param([string]$Command)
    if ($DryRun) {
        Write-Host "[DryRun] $Command"
    } else {
        & powershell -NoProfile -Command $Command
    }
}

# --- Build and Deploy Steps ---

# 1. Clean the project.
Write-Host "Cleaning the project..."
Invoke-CommandSafe "dotnet clean"
if (-not $DryRun -and $LASTEXITCODE -ne 0) {
    Write-Error "dotnet clean failed."
    exit 1
}
Write-Host ""

# 2. Publish the project to a local folder.
Write-Host "Publishing the project..."
Invoke-CommandSafe "dotnet publish -c Release -o $publishDir"
if (-not $DryRun -and $LASTEXITCODE -ne 0) {
    Write-Error "dotnet publish failed."
    exit 1
}
Write-Host ""

# 3. Create a zip file from the published output.
Write-Host "Creating deployment package..."
Invoke-CommandSafe "Compress-Archive -Path '$publishDir/*' -DestinationPath '$zipPath' -Force"
if (-not $DryRun -and $LASTEXITCODE -ne 0) {
    Write-Error "Compress-Archive failed."
    exit 1
}
Write-Host ""

# 4. Deploy the zip file to Azure Web App.
Write-Host "Deploying to Azure..."
Invoke-CommandSafe "az webapp deploy --resource-group '$ResourceGroupName' --name '$WebAppName' --src-path '$zipPath' --type zip"
if (-not $DryRun -and $LASTEXITCODE -ne 0) {
    Write-Error "Azure deployment failed."
    exit 1
}
Write-Host ""

Write-Host "Deployment completed successfully." 