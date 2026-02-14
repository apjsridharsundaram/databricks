resource "databricks_catalog" "this" {
  name         = var.catalog_name
  comment      = var.catalog_comment
  storage_root = var.storage_root
  owner        = var.catalog_owner
  force_destroy = var.force_destroy
}
