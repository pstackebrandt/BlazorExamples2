# Deployment Process (DEPRECATED)

This document outlines the steps to deploy the Blazor application to an Azure Web App using the provided PowerShell script.

## Prerequisites

Before you begin, ensure you have the following installed and configured:

1. **PowerShell**: The deployment script is a PowerShell script (`.ps1`).
2. **Azure CLI**: You must have the Azure CLI installed. You can find installation instructions in the [Azure CLI installation instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
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

1. Copy `scripts/deployment/deploy.env.example` to `scripts/deployment/deploy.env`.
2. Open `deploy.env` and fill in your Azure resource group and web app name:

    ```env
    RESOURCE_GROUP_NAME=BlazorAppTraining
    WEB_APP_NAME=blazor-examples-2
    ```

   **Note:** `deploy.env` is ignored by git and should not be committed.

## Running the Script

The script is designed to be executed from the **root directory** of the project (the same directory that contains the `.sln` file).

To run the script, open a PowerShell terminal at the project root and execute the following command:

```powershell
./scripts/deployment/deploy.ps1
```

The script will then clean, publish, package, and deploy your application to Azure using the parameters from your environment file.

### Testing with Dry Run

To test the script without performing a real deployment, you can use the `-DryRun` flag. This will print the commands that would be executed, but will not actually run them.

```powershell
./scripts/deployment/deploy.ps1 -DryRun
```
