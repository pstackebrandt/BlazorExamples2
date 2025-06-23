# This script builds and deploys the Blazor application to Azure.
# It is rather specific for my own current use.
 
# IMPORTANT:
# This script is designed to be run from the root of the project,
# where the .sln file is located.
#
# Before running, ensure you have:
# 1. Logged in to Azure with the Azure CLI (`az login`).
# 2. Set the correct Azure subscription (`az account set --subscription <your-subscription-id>`).

# --- Script Parameters ---

# The name of your resource group in Azure.
$resourceGroupName = "<your-resource-group-name>"

# The name of your Azure App Service.
$webAppName = "<your-web-app-name>"

# The path to the main project file.
$projectPath = "./BlazorExamples2/BlazorExamples2/BlazorExamples2.csproj"

# The output directory for the published files.
$publishDir = "./BlazorExamples2/BlazorExamples2/bin/Publish"

# The path for the deployment zip file.
$zipPath = "./BlazorExamples2/BlazorExamples2/blazor-app.zip"


# --- Build and Deploy Steps ---

# 1. Clean the project.
Write-Host "Cleaning the project..."
dotnet clean $projectPath
if ($LASTEXITCODE -ne 0) {
    Write-Error "dotnet clean failed."
    exit 1
}

# 2. Publish the project to a local folder.
Write-Host "Publishing the project..."
dotnet publish $projectPath -c Release -o $publishDir
if ($LASTEXITCODE -ne 0) {
    Write-Error "dotnet publish failed."
    exit 1
}

# 3. Create a zip file from the published output.
Write-Host "Creating deployment package..."
Compress-Archive -Path "$publishDir/*" -DestinationPath $zipPath -Force
if ($LASTEXITCODE -ne 0) {
    Write-Error "Compress-Archive failed."
    exit 1
}

# 4. Deploy the zip file to Azure Web App.
Write-Host "Deploying to Azure..."
az webapp deploy --resource-group $resourceGroupName --name $webAppName --src-path $zipPath --type zip
if ($LASTEXITCODE -ne 0) {
    Write-Error "Azure deployment failed."
    exit 1
}

Write-Host "Deployment completed successfully." 