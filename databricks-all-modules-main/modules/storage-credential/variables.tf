variable "name" {
  description = "Name of the storage credential"
  type        = string
}

variable "comment" {
  description = "Comment/description for the storage credential"
  type        = string
  default     = null
}

variable "owner" {
  description = "Owner of the storage credential"
  type        = string
  default     = null
}

variable "aws_iam_role" {
  description = "AWS IAM role configuration (1.16: Use restricted cross-account IAM role with least privilege)"
  type = object({
    role_arn    = string
    external_id = optional(string)
  })
  default = null
  
  validation {
    condition     = var.aws_iam_role == null || can(regex("^arn:aws:iam::[0-9]{12}:role/", var.aws_iam_role.role_arn))
    error_message = "AWS IAM role ARN must be valid format: arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME (Best Practice 1.16)."
  }
}

variable "read_only" {
  description = "Whether the storage credential is read-only"
  type        = bool
  default     = false
}

variable "skip_validation" {
  description = "Skip validation of the storage credential"
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "Force destroy even if storage credential is in use"
  type        = bool
  default     = false
}

variable "force_update" {
  description = "Force update the storage credential"
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


