variable "name" {
  description = "Name of the catalog"
  type        = string
}

variable "comment" {
  description = "Comment/description for the catalog"
  type        = string
  default     = null
}

variable "properties" {
  description = "Catalog properties (4.5: Use tags to identify sensitive catalogs for easier governance and ABAC)"
  type        = map(string)
  default     = {}
}

variable "storage_root" {
  description = "Storage root location for managed tables"
  type        = string
  default     = null
}

variable "provider_name" {
  description = "For Delta Sharing provider name"
  type        = string
  default     = null
}

variable "share_name" {
  description = "For Delta Sharing share name"
  type        = string
  default     = null
}

variable "connection_name" {
  description = "Connection name for external catalogs"
  type        = string
  default     = null
}

variable "options" {
  description = "Connection options"
  type        = map(string)
  default     = {}
}

variable "owner" {
  description = "Owner of the catalog (1.13: Use service principal as owner for production catalogs)"
  type        = string
  default     = null
}

variable "isolation_mode" {
  description = "Isolation mode (SRA: ISOLATED by default - restricts catalog to specific workspace bindings)"
  type        = string
  default     = "ISOLATED"
  
  validation {
    condition     = contains(["OPEN", "ISOLATED"], var.isolation_mode)
    error_message = "Isolation mode must be OPEN or ISOLATED. SRA default is ISOLATED for security (Best Practice 4.2)."
  }
}

variable "force_destroy" {
  description = "Force destroy even if catalog contains schemas/tables"
  type        = bool
  default     = false
}


