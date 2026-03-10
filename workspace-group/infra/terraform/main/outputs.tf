# =============================================================================
# Outputs - Workspace Group
# =============================================================================

output "group_ids" {
  description = "Map of group display_name to group ID"
  value       = module.workspace_groups.group_ids
}

output "group_names" {
  description = "List of created group display names"
  value       = module.workspace_groups.group_names
}

output "groups" {
  description = "Full map of created group resources"
  value       = module.workspace_groups.groups
}
