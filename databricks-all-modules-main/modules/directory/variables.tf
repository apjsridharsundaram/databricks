variable "path" {
  description = "Path of the directory in the workspace"
  type        = string
}

variable "delete_recursive" {
  description = "Delete directory recursively when destroying"
  type        = bool
  default     = false
}

variable "object_id" {
  description = "Unique identifier for the directory"
  type        = string
  default     = null
}




