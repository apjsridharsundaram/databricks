resource "databricks_mlflow_model" "this" {
  name        = var.name
  description = var.description
  
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}




