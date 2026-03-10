# =============================================================================
# Outputs - Workspace Role Assignment
# =============================================================================

output "group_assignment_ids" {
  description = "Map of group role assignment IDs"
  value       = module.workspace_role_assignments.group_assignment_ids
}

output "user_assignment_ids" {
  description = "Map of user role assignment IDs"
  value       = module.workspace_role_assignments.user_assignment_ids
}

output "sp_assignment_ids" {
  description = "Map of service principal role assignment IDs"
  value       = module.workspace_role_assignments.sp_assignment_ids
}
