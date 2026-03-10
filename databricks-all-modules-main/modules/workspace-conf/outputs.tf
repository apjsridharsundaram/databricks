output "workspace_conf_id" {
  description = "ID of the workspace configuration"
  value       = databricks_workspace_conf.security_settings.id
}

output "applied_settings" {
  description = "Applied workspace security settings"
  value       = databricks_workspace_conf.security_settings.custom_config
  sensitive   = false
}

output "legacy_access_disabled" {
  description = "Whether legacy access has been disabled"
  value       = var.disable_legacy_access
}

output "legacy_dbfs_disabled" {
  description = "Whether legacy DBFS has been disabled"
  value       = var.disable_legacy_dbfs
}



