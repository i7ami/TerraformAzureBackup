variable "environment" {
  description = "The environment for the backup policy (e.g., prd, ppd, dev, sbx)"
}


variable "policy_name" {
  description = "Name of backupPolicy"
}

variable "vault_name" {
  description = "Name of the associated Backup Vault"
}

variable "duration" {
  description = "duration of backup retention"
}

