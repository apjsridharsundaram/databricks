variable "account_id" {
  description = "Databricks account ID"
  type        = string
}

variable "vpc_endpoint_name" {
  description = "Name of the VPC endpoint (3.3: Use AWS PrivateLink for private connectivity)"
  type        = string
  
  validation {
    condition     = length(var.vpc_endpoint_name) > 0 && length(var.vpc_endpoint_name) <= 256
    error_message = "VPC endpoint name must be between 1 and 256 characters."
  }
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "aws_vpc_endpoint_id" {
  description = "AWS VPC endpoint ID"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}


