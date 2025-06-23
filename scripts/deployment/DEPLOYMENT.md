# Deployment Process

This document outlines the steps to deploy the Blazor application to an Azure Web App using the provided PowerShell script.

## Prerequisites

Before you begin, ensure you have the following installed and configured:

1. **PowerShell**: The deployment script is a PowerShell script (`.ps1`).
2. **Azure CLI**: You must have the Azure CLI installed. You can find installation instructions [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
3. **Azure Login**: You need to be logged into your Azure account through the CLI. Run the following command and follow the prompts:

    ```sh
    az login
    ```

4. **Set Subscription**: Make sure you have selected the correct Azure subscription where your resources are located.

    ```sh
    # List all your subscriptions
    az account list --output table

    # Set the correct subscription
    az account set --subscription "<your-subscription-id>"
    ```

## Configuration

The deployment script `deploy.ps1` needs to be configured with your specific Azure resource names.

1. Open the `scripts/deployment/deploy.ps1` file.
2. Locate the "Script Parameters" section at the top of the file.
3. Update the following variables with your values:

    ```powershell
    # The name of your resource group in Azure.
    $resourceGroupName = "<your-resource-group-name>"

    # The name of your Azure App Service.
    $webAppName = "<your-web-app-name>"
    ```

    Replace `<your-resource-group-name>` and `<your-web-app-name>` with the actual names of your Azure resources.

## Running the Script

The script is designed to be executed from the **root directory** of the project (the same directory that contains the `.sln` file).

To run the script, open a PowerShell terminal at the project root and execute the following command:

```powershell
./scripts/deployment/deploy.ps1
```

The script will then clean, publish, package, and deploy your application to Azure.
