# =============================================================================
# Outputs - Workspace Permissions
# =============================================================================

output "permission_ids" {
  description = "Map of resource_key to permission resource ID"
  value       = module.workspace_permissions.permission_ids
}

output "permissions" {
  description = "Full map of created permission resources"
  value       = module.workspace_permissions.permissions
}
