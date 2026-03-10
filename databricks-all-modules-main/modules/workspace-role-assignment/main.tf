# =============================================================================
# Workspace Role Assignment Module
# Assigns principals (groups, users, or service principals) to a Databricks
# workspace using databricks_mws_permission_assignment.
#
# This is the MISSING PIECE identified in the existing module library.
# Supports assigning USER or ADMIN roles at the workspace level.
# Prefer group-based assignment over direct user assignment.
# =============================================================================

# -----------------------------------------------------------------------------
# Group-based workspace role assignments (preferred for enterprise RBAC)
# -----------------------------------------------------------------------------
data "databricks_group" "target" {
  for_each = { for a in var.group_role_assignments : a.group_name => a }

  display_name = each.value.group_name
}

resource "databricks_mws_permission_assignment" "group" {
  for_each = { for a in var.group_role_assignments : a.group_name => a }

  workspace_id = var.workspace_id
  principal_id = data.databricks_group.target[each.key].id
  permissions  = each.value.permissions

  lifecycle {
    ignore_changes = [principal_id]
  }
}

# -----------------------------------------------------------------------------
# User-based workspace role assignments (use sparingly; prefer groups)
# -----------------------------------------------------------------------------
data "databricks_user" "target" {
  for_each = { for a in var.user_role_assignments : a.user_name => a }

  user_name = each.value.user_name
}

resource "databricks_mws_permission_assignment" "user" {
  for_each = { for a in var.user_role_assignments : a.user_name => a }

  workspace_id = var.workspace_id
  principal_id = data.databricks_user.target[each.key].id
  permissions  = each.value.permissions

  lifecycle {
    ignore_changes = [principal_id]
  }
}

# -----------------------------------------------------------------------------
# Service-principal-based workspace role assignments
# -----------------------------------------------------------------------------
data "databricks_service_principal" "target" {
  for_each = { for a in var.sp_role_assignments : a.application_id => a }

  application_id = each.value.application_id
}

resource "databricks_mws_permission_assignment" "service_principal" {
  for_each = { for a in var.sp_role_assignments : a.application_id => a }

  workspace_id = var.workspace_id
  principal_id = data.databricks_service_principal.target[each.key].id
  permissions  = each.value.permissions

  lifecycle {
    ignore_changes = [principal_id]
  }
}
