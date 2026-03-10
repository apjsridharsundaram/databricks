output "id" {
  description = "The ID of the secret scope"
  value       = databricks_secret_scope.this.id
}

output "name" {
  description = "The name of the secret scope"
  value       = databricks_secret_scope.this.name
}

output "backend_type" {
  description = "The backend type of the secret scope"
  value       = databricks_secret_scope.this.backend_type
}




