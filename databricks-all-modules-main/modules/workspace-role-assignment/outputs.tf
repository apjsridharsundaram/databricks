# =============================================================================
# Outputs for workspace-role-assignment module
# =============================================================================

output "group_assignment_ids" {
  description = "Map of group name to workspace permission assignment resource ID"
  value       = { for key, a in databricks_mws_permission_assignment.group : key => a.id }
}

output "user_assignment_ids" {
  description = "Map of user name to workspace permission assignment resource ID"
  value       = { for key, a in databricks_mws_permission_assignment.user : key => a.id }
}

output "sp_assignment_ids" {
  description = "Map of service principal application_id to workspace permission assignment resource ID"
  value       = { for key, a in databricks_mws_permission_assignment.service_principal : key => a.id }
}
