output "id" {
  description = "The ID of the storage configuration"
  value       = databricks_mws_storage_configurations.this.id
}

output "storage_configuration_id" {
  description = "The storage configuration ID"
  value       = databricks_mws_storage_configurations.this.storage_configuration_id
}

output "storage_configuration_name" {
  description = "The name of the storage configuration"
  value       = databricks_mws_storage_configurations.this.storage_configuration_name
}




