# =============================================================================
# Environment-specific variables for workspace-entitlements module
# Region: us-east-1 | Account: aws-SE-99d097-databricks
# =============================================================================

# databricks_workspace_url   = "https://<workspace>.cloud.databricks.com"
# databricks_workspace_token = "<token>"

group_names_for_entitlements = []

named_group_entitlements = [
  # {
  #   group_name            = "workspace-admins"
  #   workspace_access      = true
  #   databricks_sql_access = true
  #   allow_cluster_create  = true
  #   allow_instance_pool_create = true
  # },
  # {
  #   group_name            = "data-engineers"
  #   workspace_access      = true
  #   databricks_sql_access = true
  #   allow_cluster_create  = true
  # },
  # {
  #   group_name            = "data-analysts"
  #   workspace_access      = true
  #   databricks_sql_access = true
  # },
]

direct_group_entitlements = []
user_entitlements         = []
sp_entitlements           = []
