# =============================================================================
# Outputs for workspace-group module
# =============================================================================

output "group_ids" {
  description = "Map of group display_name to group ID"
  value       = { for name, g in databricks_group.this : name => g.id }
}

output "group_names" {
  description = "List of created group display names"
  value       = [for g in databricks_group.this : g.display_name]
}

output "groups" {
  description = "Full map of created group resources keyed by display_name"
  value       = databricks_group.this
}
