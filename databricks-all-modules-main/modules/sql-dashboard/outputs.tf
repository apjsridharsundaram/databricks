output "id" {
  description = "The ID of the SQL dashboard"
  value       = databricks_dashboard.this.id
}

output "name" {
  description = "The name of the SQL dashboard"
  value       = databricks_dashboard.this.display_name
}




