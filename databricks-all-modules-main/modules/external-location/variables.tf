variable "name" {
  description = "Name of the external location"
  type        = string
}

variable "url" {
  description = "URL of the external location (S3 path)"
  type        = string
}

variable "credential_name" {
  description = "Name of the storage credential to use"
  type        = string
}

variable "comment" {
  description = "Comment/description for the external location"
  type        = string
  default     = null
}

variable "owner" {
  description = "Owner of the external location"
  type        = string
  default     = null
}

variable "read_only" {
  description = "Whether the external location is read-only (4.3: Use for workspace-specific access patterns)"
  type        = bool
  default     = false
}

variable "force_update" {
  description = "Force update of the external location"
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "Force destroy of the external location"
  type        = bool
  default     = false
}

variable "isolation_mode" {
  description = "Isolation mode (SRA: ISOLATION_MODE_ISOLATED by default - restricts to specific workspace)"
  type        = string
  default     = "ISOLATION_MODE_ISOLATED"
  
  validation {
    condition     = contains(["ISOLATION_MODE_ISOLATED", "ISOLATION_MODE_OPEN"], var.isolation_mode)
    error_message = "Isolation mode must be ISOLATION_MODE_ISOLATED or ISOLATION_MODE_OPEN. SRA default is ISOLATED."
  }
}

variable "skip_validation" {
  description = "Skip validation of the external location"
  type        = bool
  default     = false
}
