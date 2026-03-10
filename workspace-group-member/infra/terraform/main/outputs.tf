# =============================================================================
# Outputs - Workspace Group Member
# =============================================================================

output "membership_ids" {
  description = "Map of membership key to resource ID"
  value       = module.workspace_group_members.membership_ids
}

output "memberships" {
  description = "Full map of created membership resources"
  value       = module.workspace_group_members.memberships
}
