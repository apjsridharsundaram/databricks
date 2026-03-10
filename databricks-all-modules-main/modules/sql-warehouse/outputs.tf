output "id" {
  description = "The ID of the SQL warehouse"
  value       = databricks_sql_endpoint.this.id
}

output "name" {
  description = "The name of the SQL warehouse"
  value       = databricks_sql_endpoint.this.name
}

output "jdbc_url" {
  description = "JDBC URL for the SQL warehouse"
  value       = databricks_sql_endpoint.this.jdbc_url
}

output "odbc_params" {
  description = "ODBC parameters"
  value       = databricks_sql_endpoint.this.odbc_params
  sensitive   = true
}

output "data_source_id" {
  description = "Data source ID"
  value       = databricks_sql_endpoint.this.data_source_id
}

output "state" {
  description = "Current state of the warehouse"
  value       = databricks_sql_endpoint.this.state
}




