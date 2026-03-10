output "id" {
  description = "The ID of the table"
  value       = databricks_sql_table.this.id
}

output "name" {
  description = "The name of the table"
  value       = databricks_sql_table.this.name
}

output "full_name" {
  description = "Full name (catalog.schema.table)"
  value       = "${databricks_sql_table.this.catalog_name}.${databricks_sql_table.this.schema_name}.${databricks_sql_table.this.name}"
}




