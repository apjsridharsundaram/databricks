resource "databricks_token" "this" {
  comment          = var.comment
  lifetime_seconds = var.lifetime_seconds
}




