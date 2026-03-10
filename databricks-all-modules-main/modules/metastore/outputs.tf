output "id" {
  description = "The ID of the metastore"
  value       = databricks_metastore.this.id
}

output "metastore_id" {
  description = "The metastore ID"
  value       = databricks_metastore.this.metastore_id
}

output "name" {
  description = "The name of the metastore"
  value       = databricks_metastore.this.name
}

output "storage_root" {
  description = "The storage root of the metastore"
  value       = databricks_metastore.this.storage_root
}




