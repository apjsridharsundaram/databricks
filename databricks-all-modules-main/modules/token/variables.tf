variable "comment" {
  description = "Comment for the token"
  type        = string
  default     = null
}

variable "lifetime_seconds" {
  description = "Lifetime of the token in seconds (1.10: PATs NOT recommended - use OAuth. If required, max 30 days = 2592000)"
  type        = number
  default     = 2592000  # 30 days - security best practice
  
  validation {
    condition     = var.lifetime_seconds >= 3600 && var.lifetime_seconds <= 7776000
    error_message = "Token lifetime must be 1 hour (3600) to 90 days (7776000). Shorter is more secure (Best Practice 1.10)."
  }
}


