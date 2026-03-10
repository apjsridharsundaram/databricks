# =============================================================================
# Outputs for workspace-group-member module
# =============================================================================

output "membership_ids" {
  description = "Map of membership key (group_id-member_id) to membership resource ID"
  value       = { for key, m in databricks_group_member.this : key => m.id }
}

output "memberships" {
  description = "Full map of group membership resources"
  value       = databricks_group_member.this
}
