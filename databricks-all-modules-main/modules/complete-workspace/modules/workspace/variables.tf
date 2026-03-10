variable "workspace_name" {
  description = "The name of the Databricks workspace"
  type        = string
}

variable "account_id" {
  description = "Databricks account ID"
  type        = string
}

variable "aws_region" {
  description = "AWS region where the workspace will be created"
  type        = string
}

variable "credentials_id" {
  description = "ID of the credentials configuration"
  type        = string
}

variable "storage_configuration_id" {
  description = "ID of the storage configuration"
  type        = string
}

variable "network_id" {
  description = "ID of the network configuration"
  type        = string
  default     = null
}

variable "token_config" {
  description = "Token configuration for the workspace"
  type = object({
    comment          = string
    lifetime_seconds = number
  })
  default = null
}

variable "deployment_name" {
  description = "Deployment name for the workspace URL prefix. Must be enabled by a Databricks representative."
  type        = string
  default     = null
  nullable    = true
}

variable "custom_tags" {
  description = "Custom tags to apply to the workspace"
  type        = map(string)
  default     = {}
}

variable "pricing_tier" {
  description = "Pricing tier for the workspace (SRA: ENTERPRISE required for Unity Catalog and security features)"
  type        = string
  default     = "ENTERPRISE"

  validation {
    condition     = contains(["STANDARD", "PREMIUM", "ENTERPRISE"], var.pricing_tier)
    error_message = "Pricing tier must be STANDARD, PREMIUM, or ENTERPRISE. SRA requires ENTERPRISE."
  }
}

variable "private_access_settings_id" {
  description = "ID of the private access settings"
  type        = string
  default     = null
}

variable "storage_customer_managed_key_id" {
  description = "ID of the customer managed key for storage (2.9: Highly recommended for sensitive data)"
  type        = string
  default     = null
}

variable "managed_services_customer_managed_key_id" {
  description = "ID of the customer managed key for managed services (2.8: Protects notebooks, secrets, etc.)"
  type        = string
  default     = null
}
