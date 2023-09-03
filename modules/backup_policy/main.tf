provider "azurerm" {
  features {}
}

resource "azurerm_resource_group_template_deployment" "blob_backup_policy" {
  name                = "blob-backup-policy-${var.environment}"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  parameters_content = jsonencode({
    "policy_name" = {
      value = join("-", [var.policy_name, var.environment])
    },  
    "vault_name" = {
      value = var.vault_name
    },
    "duration" = {
      value = var.duration
    }
  })

  template_content = <<TEMPLATE
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "duration": {
            "type": "string",
            "defaultValue": "",
            "metadata": {
                "description": "The duration of the backup policy."
            }
        },
        "policy_name": {
            "type": "string",
            "defaultValue": "",
            "metadata": {
                "description": "The name of the backup policy."
            }
        },
        "vault_name": {
            "type": "string",
            "defaultValue": "",
            "metadata": {
                "description": "The name of the backup vault."
            }
        }
    },
    "resources": [
        {
            "type": "Microsoft.DataProtection/backupVaults/backupPolicies",
            "apiVersion": "2023-05-01",
            "name": "[concat(parameters('vault_name'), '/', parameters('policy_name'))]",
            "properties": {
                "policyRules": [
                    {
                        "lifecycles": [
                            {
                                "deleteAfter": {
                                    "objectType": "AbsoluteDeleteOption",
                                    "duration": "[parameters('duration')]"
                                },
                                "targetDataStoreCopySettings": [],
                                "sourceDataStore": {
                                    "dataStoreType": "VaultStore",
                                    "objectType": "DataStoreInfoBase"
                                }
                            }
                        ],
                        "isDefault": true,
                        "name": "Default",
                        "objectType": "AzureRetentionRule"
                    },
                    {
                        "backupParameters": {
                            "backupType": "Discrete",
                            "objectType": "AzureBackupParams"
                        },
                        "trigger": {
                            "schedule": {
                                "repeatingTimeIntervals": [
                                    "R/2023-09-02T10:00:00+01:00/P1D"
                                ],
                                "timeZone": "Romance Standard Time"
                            },
                            "taggingCriteria": [
                                {
                                    "tagInfo": {
                                        "tagName": "Default",
                                        "id": "Default_"
                                    },
                                    "taggingPriority": 99,
                                    "isDefault": true
                                }
                            ],
                            "objectType": "ScheduleBasedTriggerContext"
                        },
                        "dataStore": {
                            "dataStoreType": "VaultStore",
                            "objectType": "DataStoreInfoBase"
                        },
                        "name": "BackupDaily",
                        "objectType": "AzureBackupRule"
                    }
                ],
                "datasourceTypes": [
                    "Microsoft.Storage/storageAccounts/blobServices"
                ],
                "objectType": "BackupPolicy"
            }
        }
    ]
}
TEMPLATE
}
