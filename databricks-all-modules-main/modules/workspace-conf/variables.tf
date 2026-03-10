variable "enable_results_downloading" {
  description = "Enable results downloading from notebooks (SRA: false - prevents data exfiltration)"
  type        = bool
  default     = false
}

variable "enable_notebook_table_clipboard" {
  description = "Enable notebook table clipboard (SRA: false - prevents data exfiltration)"
  type        = bool
  default     = false
}

variable "enable_verbose_audit_logs" {
  description = "Enable verbose audit logs (SRA: true - required for security monitoring)"
  type        = bool
  default     = true
}

variable "enable_dbfs_file_browser" {
  description = "Enable DBFS file browser (SRA: false - production data should not be in DBFS)"
  type        = bool
  default     = false
}

variable "enable_export_notebook" {
  description = "Enable notebook export (SRA: false - prevents data/code exfiltration)"
  type        = bool
  default     = false
}

variable "enforce_user_isolation" {
  description = "Enforce user isolation (SRA: true - mandatory for security)"
  type        = bool
  default     = true
}

variable "store_results_in_customer_account" {
  description = "Store interactive notebook results in customer account (SRA: true - data sovereignty)"
  type        = bool
  default     = true
}

variable "enable_upload_data_uis" {
  description = "Enable upload data UIs (SRA: false - data should come from controlled sources)"
  type        = bool
  default     = false
}

variable "disable_legacy_access" {
  description = "Disable legacy access settings (SRA: true - remove deprecated access patterns)"
  type        = bool
  default     = true
}

variable "disable_legacy_dbfs" {
  description = "Disable legacy DBFS (SRA: true - force Unity Catalog usage)"
  type        = bool
  default     = true
}

variable "additional_workspace_config" {
  description = "Additional workspace configuration settings to merge"
  type        = map(string)
  default     = {}
}

variable "enable_ip_access_lists" {
  description = "Enable IP access lists enforcement (SRA: true when using IP restrictions)"
  type        = bool
  default     = true
}

variable "enable_web_terminal" {
  description = "Enable web terminal (SRA: false - prevents unauthorized shell access)"
  type        = bool
  default     = false
}

variable "max_token_lifetime_days" {
  description = "Maximum token lifetime in days (SRA: set to limit long-lived tokens, 0 = no limit)"
  type        = number
  default     = 90
}


