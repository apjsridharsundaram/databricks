variable "list_type" {
  description = "Type of IP access list (ALLOW or BLOCK)"
  type        = string

  validation {
    condition     = contains(["ALLOW", "BLOCK"], var.list_type)
    error_message = "List type must be ALLOW or BLOCK"
  }
}

variable "label" {
  description = "Label for the IP access list"
  type        = string
}

variable "ip_addresses" {
  description = "List of IP addresses or CIDR blocks"
  type        = list(string)
}

variable "enabled" {
  description = "Whether the IP access list is enabled"
  type        = bool
  default     = true
}




