variable "databricks_account_id" {
  description = "Databricks Account ID"
  type        = string
}

variable "workspace_name" {
  description = "Name for the workspace"
  type        = string
  default     = "example-workspace"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}


