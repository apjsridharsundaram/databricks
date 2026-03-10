variable "name" {
  description = "Name of the global init script"
  type        = string
}

variable "enabled" {
  description = "Whether the script is enabled"
  type        = bool
  default     = true
}

variable "script_source" {
  description = "Path to the script file on the local filesystem"
  type        = string
  default     = null
}

variable "content_base64" {
  description = "Base64-encoded content of the script"
  type        = string
  default     = null
}

variable "position" {
  description = "Position/order of the script execution"
  type        = number
  default     = null
}




