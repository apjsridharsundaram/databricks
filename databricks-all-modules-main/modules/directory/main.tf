resource "databricks_directory" "this" {
  path                   = var.path
  delete_recursive       = var.delete_recursive
  object_id              = var.object_id
}




