resource "azurerm_monitor_action_group" "example" {
  name                = "example"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "example"
  email_receiver {
    name          = "email"
    email_address = "your-email@example.com"
  }
}

resource "azurerm_monitor_metric_alert" "backup_success_alert" {
  name                = "backup-success-alert"
  resource_group_name = azurerm_resource_group.example.name
  scopes              = [module.prd_backup_vault.vault_id, module.ppd_backup_vault.vault_id, module.dev_backup_vault.vault_id, module.sbx_backup_vault.vault_id]
  description         = "Alert when backup succeeds"
  severity            = 2
  enabled             = true

  criteria {
    metric_namespace = "Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/items"
    metric_name      = "BackupItemSuccessCount"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 0
  }

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}

output "alert_id" {
  value = azurerm_monitor_metric_alert.backup_success_alert.id
}


