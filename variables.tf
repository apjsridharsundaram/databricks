variable "databricks_host" {
  description = "Databricks workspace URL, e.g. https://adb-1234567890123456.7.azuredatabricks.net"
  type        = string
}

variable "databricks_token" {
  description = "Databricks personal access token"
  type        = string
  sensitive   = true
}

variable "catalog_name" {
  description = "Name of the Unity Catalog catalog to create"
  type        = string
}

variable "catalog_comment" {
  description = "Optional comment for the catalog"
  type        = string
  default     = "Managed by Terraform"
}

variable "storage_root" {
  description = "Optional cloud storage path for managed tables, e.g. s3://bucket/path or abfss://container@account.dfs.core.windows.net/path"
  type        = string
  default     = null
}

variable "catalog_owner" {
  description = "Optional owner principal (user/group/service principal)"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Whether to delete all child objects before deleting the catalog"
  type        = bool
  default     = false
}
