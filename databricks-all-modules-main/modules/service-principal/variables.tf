variable "application_id" {
  description = "UUID/application ID of the service principal. Omit to let Databricks auto-generate."
  type        = string
  default     = null
}

variable "display_name" {
  description = "Display name of the service principal"
  type        = string
  default     = null
}

variable "active" {
  description = "Whether the service principal is active"
  type        = bool
  default     = true
}

variable "allow_cluster_create" {
  description = "Allow the service principal to create clusters"
  type        = bool
  default     = false
}

variable "allow_instance_pool_create" {
  description = "Allow the service principal to create instance pools"
  type        = bool
  default     = false
}

variable "databricks_sql_access" {
  description = "Allow the service principal to access Databricks SQL"
  type        = bool
  default     = false
}

variable "workspace_access" {
  description = "Allow the service principal to access the workspace"
  type        = bool
  default     = true
}

variable "external_id" {
  description = "External ID for SCIM provisioning"
  type        = string
  default     = null
}

variable "force" {
  description = "Force the service principal to be created even if it already exists"
  type        = bool
  default     = false
}

variable "home" {
  description = "Home directory path for the service principal"
  type        = string
  default     = null
}

variable "repos" {
  description = "Repos directory path for the service principal"
  type        = string
  default     = null
}

variable "acl_principal_id" {
  description = "ACL principal ID"
  type        = string
  default     = null
}




