resource "databricks_cluster_policy" "this" {
  name                               = var.name
  definition                         = var.definition
  description                        = var.description
  policy_family_id                   = var.policy_family_id
  policy_family_definition_overrides = var.policy_family_definition_overrides
  max_clusters_per_user              = var.max_clusters_per_user
}
