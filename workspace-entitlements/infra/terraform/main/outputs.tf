# =============================================================================
# Outputs - Workspace Entitlements
# =============================================================================

output "group_entitlement_ids" {
  description = "Map of group entitlement IDs"
  value       = module.workspace_entitlements.group_entitlement_ids
}

output "user_entitlement_ids" {
  description = "Map of user entitlement IDs"
  value       = module.workspace_entitlements.user_entitlement_ids
}

output "sp_entitlement_ids" {
  description = "Map of service principal entitlement IDs"
  value       = module.workspace_entitlements.sp_entitlement_ids
}
