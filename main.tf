provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name = "AzureBackup"
}

module "prd_backup_vault" {
  source              = "./modules/backup_vault"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  environment         = "prd"
}

module "prd_blob_backup_policy" {
  source      = "./modules/backup_policy"
  environment = "prd"
  policy_name = "blobvaultedpolicy"
  duration    = "P7D"
  vault_name  = module.prd_backup_vault.vault_name
}


module "ppd_backup_vault" {
  source              = "./modules/backup_vault"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  environment         = "ppd"
}

module "ppd_blob_backup_policy" {
  source      = "./modules/backup_policy"
  environment = "ppd"
  policy_name = "blobvaultedpolicy"
  duration    = "P7D"
  vault_name  = module.ppd_backup_vault.vault_name
}



# module "alerts" {
#   source = "./alerts"
#   prd_vault_name = module.prd_backup_vault.vault_name
#   ppd_vault_name = module.ppd_backup_vault.vault_name
#   dev_vault_name = module.dev_backup_vault.vault_name
#   sbx_vault_name = module.sbx_backup_vault.vault_name
# }
