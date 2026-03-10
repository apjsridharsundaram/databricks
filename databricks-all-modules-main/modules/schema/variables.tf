variable "catalog_name" {
  description = "Name of the parent catalog"
  type        = string
}

variable "name" {
  description = "Name of the schema"
  type        = string
}

variable "comment" {
  description = "Comment/description for the schema"
  type        = string
  default     = null
}

variable "properties" {
  description = "Schema properties"
  type        = map(string)
  default     = {}
}

variable "storage_root" {
  description = "Storage root location for managed tables"
  type        = string
  default     = null
}

variable "owner" {
  description = "Owner of the schema"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Force destroy even if schema contains tables"
  type        = bool
  default     = false
}




