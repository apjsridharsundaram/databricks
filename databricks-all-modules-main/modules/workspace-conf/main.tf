# Databricks Workspace Configuration Module
# Implements SRA security settings for workspace-level configurations
# Based on: https://github.com/databricks/terraform-databricks-sra

resource "databricks_workspace_conf" "security_settings" {
  custom_config = merge(
    {
      # SRA: Disable results downloading (2.13: Data exfiltration prevention)
      "enableResultsDownloading" = var.enable_results_downloading ? "true" : "false"
      
      # SRA: Disable notebook table clipboard (2.13: Data exfiltration prevention)
      "enableNotebookTableClipboard" = var.enable_notebook_table_clipboard ? "true" : "false"
      
      # SRA: Enable verbose audit logs (5.3: Required for security monitoring)
      "enableVerboseAuditLogs" = var.enable_verbose_audit_logs ? "true" : "false"
      
      # SRA: Disable DBFS file browser (2.3: Avoid storing production data in DBFS)
      "enableDbfsFileBrowser" = var.enable_dbfs_file_browser ? "true" : "false"
      
      # SRA: Disable notebook export (2.13: Data exfiltration prevention)
      "enableExportNotebook" = var.enable_export_notebook ? "true" : "false"
      
      # SRA: Enforce user isolation (1.14: Mandatory for shared compute)
      "enforceUserIsolation" = var.enforce_user_isolation ? "true" : "false"
      
      # SRA: Store results in customer account (2.3: Keep data in customer control)
      "storeInteractiveNotebookResultsInCustomerAccount" = var.store_results_in_customer_account ? "true" : "false"
      
      # SRA: Disable upload data UIs (Data governance control)
      "enableUploadDataUis" = var.enable_upload_data_uis ? "true" : "false"

      "enableIpAccessLists"  = var.enable_ip_access_lists ? "true" : "false"
      "enableWebTerminal"    = var.enable_web_terminal ? "true" : "false"
      "maxTokenLifetimeDays" = tostring(var.max_token_lifetime_days)
    },
    var.additional_workspace_config
  )
}

# Disable legacy access settings
resource "databricks_disable_legacy_access_setting" "access" {
  count = var.disable_legacy_access ? 1 : 0
  
  disable_legacy_access {
    value = true
  }
}

# Disable legacy DBFS settings
resource "databricks_disable_legacy_dbfs_setting" "dbfs" {
  count = var.disable_legacy_dbfs ? 1 : 0
  
  disable_legacy_dbfs {
    value = true
  }
}



