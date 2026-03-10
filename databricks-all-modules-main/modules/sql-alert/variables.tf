variable "query_id" {
  description = "ID of the SQL query to monitor"
  type        = string
}

variable "name" {
  description = "Name of the alert"
  type        = string
}

variable "parent" {
  description = "Parent folder path (e.g. folders/<folder_id>)"
  type        = string
  default     = null
}

variable "rearm" {
  description = "Number of seconds to wait after alert is triggered before checking again"
  type        = number
  default     = null
}

variable "options_column" {
  description = "Column to check"
  type        = string
}

variable "options_op" {
  description = "Comparison operator (>, <, >=, <=, ==, !=)"
  type        = string
}

variable "options_value" {
  description = "Value to compare against"
  type        = string
}

variable "options_muted" {
  description = "Whether the alert is muted. Retained for variable compatibility; databricks_alert state is read-only and cannot be set at create time."
  type        = bool
  default     = false
}

variable "options_custom_subject" {
  description = "Custom email subject"
  type        = string
  default     = null
}

variable "options_custom_body" {
  description = "Custom email body"
  type        = string
  default     = null
}




