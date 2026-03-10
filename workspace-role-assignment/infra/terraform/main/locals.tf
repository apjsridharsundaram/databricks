# =============================================================================
# Locals - Workspace Role Assignment
# =============================================================================

locals {
  # Default role assignments - customize in tfvars
  group_role_assignments = var.group_role_assignments
  user_role_assignments  = var.user_role_assignments
  sp_role_assignments    = var.sp_role_assignments
}
