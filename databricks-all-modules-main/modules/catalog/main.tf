resource "databricks_catalog" "this" {
  name           = var.name
  comment        = var.comment
  properties     = var.properties
  storage_root   = var.storage_root
  provider_name  = var.provider_name
  share_name     = var.share_name
  connection_name = var.connection_name
  options        = var.options
  owner          = var.owner
  isolation_mode = var.isolation_mode
  force_destroy  = var.force_destroy
}




