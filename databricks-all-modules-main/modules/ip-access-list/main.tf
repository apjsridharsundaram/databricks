resource "databricks_ip_access_list" "this" {
  list_type    = var.list_type
  label        = var.label
  ip_addresses = var.ip_addresses
  enabled      = var.enabled
}




