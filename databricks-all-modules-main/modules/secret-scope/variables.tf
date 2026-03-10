variable "name" {
  description = "The name of the secret scope"
  type        = string
}

variable "keyvault_metadata" {
  description = "Azure Key Vault metadata (not used for AWS)"
  type = object({
    resource_id = string
    dns_name    = string
  })
  default = null
}

variable "initial_manage_principal" {
  description = "The principal that is initially granted MANAGE permission to the created scope"
  type        = string
  default     = "users"
}




