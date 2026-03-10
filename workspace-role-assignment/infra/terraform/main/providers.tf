# =============================================================================
# Provider Configuration - Workspace Role Assignment
# Requires ACCOUNT-LEVEL provider (not workspace-level)
# =============================================================================

provider "databricks" {
  alias = "account"
  # host       = var.databricks_account_url
  # account_id = var.databricks_account_id
  # token      = var.databricks_account_token
}
