# Deploys the Blazor application to Azure Web App.
#
# Usage:
# Run this script from the solution root directory.
#   pwsh ./deploy.ps1
#   pwsh ./deploy.ps1 -DryRun
#   pwsh ./deploy.ps1 -BuildOnly
#   pwsh ./deploy.ps1 -DryRun -BuildOnly -Debug
#
# Parameters:
#   -DryRun: Shows commands without executing them
#   -BuildOnly: Creates deployment package without deploying
#   -Debug: Shows full command lines while executing them
#
# Before running, ensure you have:
# 1. Created deploy.env with your Azure settings
# 2. Logged in to Azure CLI (`az login`)
# 3. Set the correct Azure subscription

param(
    [switch]$DryRun,
    [switch]$BuildOnly,
    [switch]$Debug
)

# --- Build and Deploy ---

# 1. Clean
Write-Host "Cleaning the project..."
if ($DryRun) {
    Write-Host "[DryRun] dotnet clean"
} else {
    if ($Debug) { Write-Host "[Executing] dotnet clean" -ForegroundColor Cyan }
    dotnet clean
    if ($LASTEXITCODE -ne 0) {
        Write-Error "dotnet clean failed."
        exit 1
    }
}

# 2. Publish
Write-Host "Publishing the solution..."
if ($DryRun) {
    Write-Host "[DryRun] dotnet publish -c Release -o ./bin/Publish"
} else {
    if ($Debug) { Write-Host "[Executing] dotnet publish -c Release -o ./bin/Publish" -ForegroundColor Cyan }
    dotnet publish -c Release -o ./bin/Publish
    if ($LASTEXITCODE -ne 0) {
        Write-Error "dotnet publish failed."
        exit 1
    }
}

# 3. Create deployment package
Write-Host "Creating deployment package..."
if ($DryRun) {
    Write-Host "[DryRun] Compress-Archive -Path `"./bin/Publish/*`" -DestinationPath `"./blazor-app.zip`" -Force"
} else {
    if ($Debug) { Write-Host "[Executing] Compress-Archive -Path `"./bin/Publish/*`" -DestinationPath `"./blazor-app.zip`" -Force" -ForegroundColor Cyan }
    Compress-Archive -Path "./bin/Publish/*" -DestinationPath "./blazor-app.zip" -Force
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Compress-Archive failed."
        exit 1
    }
}

# 4. Deploy or finish
if ($BuildOnly) {
    Write-Host "BuildOnly mode: Deployment package created successfully."
} else {
    # Load environment variables only when needed for deployment
    $envFile = "./deploy.env"
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

    Write-Host "`n--- Deployment Variables ---"
    Write-Host "Resource Group: $RESOURCE_GROUP_NAME"
    Write-Host "Web App Name:   $WEB_APP_NAME"
    Write-Host "---------------------------`n"

    Write-Host "Deploying to Azure..."
    if ($DryRun) {
        Write-Host "[DryRun] az webapp deploy --resource-group `"$RESOURCE_GROUP_NAME`" --name `"$WEB_APP_NAME`" --src-path `"./blazor-app.zip`" --type zip"
    } else {
        if ($Debug) { Write-Host "[Executing] az webapp deploy --resource-group `"$RESOURCE_GROUP_NAME`" --name `"$WEB_APP_NAME`" --src-path `"./blazor-app.zip`" --type zip" -ForegroundColor Cyan }
        az webapp deploy --resource-group "$RESOURCE_GROUP_NAME" --name "$WEB_APP_NAME" --src-path "./blazor-app.zip" --type zip
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Azure deployment failed."
            exit 1
        }
    }
    Write-Host "Deployment completed successfully."
} 