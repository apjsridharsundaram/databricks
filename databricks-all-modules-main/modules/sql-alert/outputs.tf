output "id" {
  description = "The ID of the SQL alert"
  value       = databricks_alert.this.id
}

output "name" {
  description = "The name of the SQL alert"
  value       = databricks_alert.this.display_name
}




