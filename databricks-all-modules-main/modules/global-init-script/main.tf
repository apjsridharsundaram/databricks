resource "databricks_global_init_script" "this" {
  name    = var.name
  enabled = var.enabled
  
  source  = var.script_source
  content_base64 = var.content_base64
  
  position = var.position
}




