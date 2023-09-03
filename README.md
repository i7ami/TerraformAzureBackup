# Terraform Azure Backup Configuration

This Terraform configuration allows you to set up Azure Backup resources, including a backup vault and backup policies, using the AzureRM provider. It's designed to create resources in multiple environments within a specified Azure resource group.

## Prerequisites

Before using this Terraform configuration, ensure that you have the following:

- [Terraform](https://www.terraform.io/downloads.html) installed on your system.
- Appropriate Azure credentials configured. You can set them using the Azure CLI or environment variables.

## Configuration

This Terraform configuration is structured to create Azure Backup resources for both a production (`prd`) and pre-production (`ppd`) environment within the same Azure resource group (`AzureBackup` in this example). The configuration includes the following modules:

### Azure Backup Vault

The `backup_vault` module (`./modules/backup_vault`) creates an Azure Backup vault for the specified environment. It uses the Azure Resource Manager (azurerm) provider for this task. You need to provide the following parameters:

- `source`: The module source path.
- `resource_group_name`: The name of the Azure resource group where the vault should be created.
- `location`: The Azure region where the vault should be located.
- `environment`: The environment identifier (e.g., `prd` or `ppd`).

Example:
```hcl
module "prd_backup_vault" {
  source              = "./modules/backup_vault"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  environment         = "prd"
}
```
## Azure Blob Backup Policy

The `backup_policy` module (`./modules/backup_policy`) is responsible for creating a backup policy tailored for Azure Blob storage. This policy defines essential settings such as policy name, retention duration, and the associated vault. When implementing this module, you will need to provide the following parameters:

- `source`: The module source path.
- `resource_group_name`: The name of the Azure resource group.
- `environment`: The environment identifier (e.g., `prd` or `ppd`).
- `policy_name`: The name assigned to the backup policy.
- `duration`: The retention duration for backups (e.g., `"P7D"` for a 7-day retention period).
- `vault_name`: The name of the Azure Backup vault linked to this policy.

Here's an example of how to use the `backup_policy` module within your Terraform configuration:

```hcl
module "prd_blob_backup_policy" {
  source      = "./modules/backup_policy"
  resource_group_name = data.azurerm_resource_group.rg.name
  environment = "prd"
  policy_name = "blobvaultedpolicy"
  duration    = "P7D"
  vault_name  = module.prd_backup_vault.vault_name
}
```

## Usage

To implement this Azure Blob Backup Policy, follow these steps:

1. **Clone Repository**: Begin by cloning this repository to your local machine.

2. **Customize Configuration**: Customize the variables and module parameters within your Terraform configuration to align with your specific backup policy requirements.

3. **Initialize Terraform**: Run `terraform init` to initialize the Terraform workspace, ensuring that all necessary providers and modules are set up.

4. **Apply Configuration**: Execute `terraform apply` to create the Azure Backup resources specified in your configuration. This action will provision the Azure Blob Backup Policy as defined.

## Notes

- **Permissions and Credentials**: Ensure that you possess the necessary permissions and have valid Azure credentials to create resources within the specified resource group.

- **Customization**: Remember to adjust the module sources and variables to match your specific requirements, including naming conventions and resource settings. This allows you to tailor the backup policy to your organization's needs.

- **Monitoring and Alerting**: If you intend to establish monitoring or alerting for your Azure Backup resources, you can uncomment and configure the alerts module within your Terraform configuration as needed.
