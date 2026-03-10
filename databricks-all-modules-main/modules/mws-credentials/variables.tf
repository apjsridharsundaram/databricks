variable "account_id" {
  description = "Databricks account ID"
  type        = string
}

variable "credentials_name" {
  description = "Name of the credentials configuration"
  type        = string
}

variable "role_arn" {
  description = "ARN of the IAM role for cross-account access"
  type        = string
}




