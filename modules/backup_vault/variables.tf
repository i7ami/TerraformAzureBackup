variable "environment" {
  description = "The environment for the backup vault (e.g., prd, ppd, dev, sbx)"
}

variable "resource_group_name" {
  description = "The resource group where to deploy the backup vault"
}

variable "location" {
  description = "The location of the deployement"
}
