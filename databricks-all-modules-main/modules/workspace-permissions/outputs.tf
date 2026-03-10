# =============================================================================
# Outputs for workspace-permissions module
# =============================================================================

output "permission_ids" {
  description = "Map of resource_key to permissions resource ID"
  value       = { for key, p in databricks_permissions.this : key => p.id }
}

output "permissions" {
  description = "Full map of permission resources keyed by resource_key"
  value       = databricks_permissions.this
}
