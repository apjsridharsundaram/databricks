resource "databricks_workspace_conf" "security_settings" {
  custom_config = merge(
    {
      "enableResultsDownloading"                          = var.enable_results_downloading ? "true" : "false"
      "enableNotebookTableClipboard"                      = var.enable_notebook_table_clipboard ? "true" : "false"
      "enableVerboseAuditLogs"                            = var.enable_verbose_audit_logs ? "true" : "false"
      "enableDbfsFileBrowser"                             = var.enable_dbfs_file_browser ? "true" : "false"
      "enableExportNotebook"                              = var.enable_export_notebook ? "true" : "false"
      "enforceUserIsolation"                              = var.enforce_user_isolation ? "true" : "false"
      "storeInteractiveNotebookResultsInCustomerAccount"  = var.store_results_in_customer_account ? "true" : "false"
      "enableUploadDataUis"                               = var.enable_upload_data_uis ? "true" : "false"
    },
    var.additional_workspace_config
  )
}

resource "databricks_disable_legacy_access_setting" "access" {
  count = var.disable_legacy_access ? 1 : 0
  
  disable_legacy_access {
    value = true
  }
}

resource "databricks_disable_legacy_dbfs_setting" "dbfs" {
  count = var.disable_legacy_dbfs ? 1 : 0
  
  disable_legacy_dbfs {
    value = true
  }
}
