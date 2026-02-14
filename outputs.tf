output "catalog_id" {
  description = "Catalog identifier"
  value       = databricks_catalog.this.id
}

output "catalog_name" {
  description = "Created catalog name"
  value       = databricks_catalog.this.name
}
