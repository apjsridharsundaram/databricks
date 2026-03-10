output "id" {
  description = "The ID of the catalog"
  value       = databricks_catalog.this.id
}

output "name" {
  description = "The name of the catalog"
  value       = databricks_catalog.this.name
}

output "metastore_id" {
  description = "The ID of the metastore"
  value       = databricks_catalog.this.metastore_id
}




