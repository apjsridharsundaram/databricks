variable "scope" {
  description = "The name of the secret scope"
  type        = string
}

variable "key" {
  description = "The key for the secret"
  type        = string
}

variable "string_value" {
  description = "The value of the secret"
  type        = string
  sensitive   = true
}




