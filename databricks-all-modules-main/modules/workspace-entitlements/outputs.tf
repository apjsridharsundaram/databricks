# =============================================================================
# Outputs for workspace-entitlements module
# =============================================================================

output "group_entitlement_ids" {
  description = "Map of group_id to entitlements resource ID"
  value       = { for key, e in databricks_entitlements.group : key => e.id }
}

output "user_entitlement_ids" {
  description = "Map of user_id to entitlements resource ID"
  value       = { for key, e in databricks_entitlements.user : key => e.id }
}

output "sp_entitlement_ids" {
  description = "Map of service_principal_id to entitlements resource ID"
  value       = { for key, e in databricks_entitlements.service_principal : key => e.id }
}
