output "id" {
  description = "The ID of the SQL query"
  value       = databricks_query.this.id
}

output "name" {
  description = "The name of the SQL query"
  value       = databricks_query.this.display_name
}




