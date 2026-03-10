resource "databricks_secret" "this" {
  scope        = var.scope
  key          = var.key
  string_value = var.string_value
}




