resource "databricks_mws_storage_configurations" "this" {
  account_id                 = var.account_id
  storage_configuration_name = var.storage_configuration_name
  bucket_name                = var.bucket_name
}




