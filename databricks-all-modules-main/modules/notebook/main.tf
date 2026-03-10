resource "databricks_notebook" "this" {
  path     = var.path
  language = var.language
  format   = var.format

  content_base64 = var.content_base64
  source         = var.notebook_source

  object_id = var.object_id
}




