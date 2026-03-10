output "id" {
  description = "The ID of the schema"
  value       = databricks_schema.this.id
}

output "name" {
  description = "The name of the schema"
  value       = databricks_schema.this.name
}

output "full_name" {
  description = "Full name (catalog.schema)"
  value       = "${databricks_schema.this.catalog_name}.${databricks_schema.this.name}"
}




