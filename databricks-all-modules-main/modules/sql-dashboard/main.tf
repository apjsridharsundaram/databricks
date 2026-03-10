resource "databricks_dashboard" "this" {
  display_name  = var.name
  parent_path   = var.parent
  warehouse_id  = var.warehouse_id
}
