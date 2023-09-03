resource "azurerm_data_protection_backup_vault" "backup_vault" {
  name                = "backup-vault-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"
  #immutability        = "Locked" or "Unlocked" or "Disabled"
  identity {
    type = "SystemAssigned"
  }
  tags = {
    environment = var.environment
  }
}


