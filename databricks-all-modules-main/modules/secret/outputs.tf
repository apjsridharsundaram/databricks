output "id" {
  description = "The ID of the secret"
  value       = databricks_secret.this.id
}

output "key" {
  description = "The key of the secret"
  value       = databricks_secret.this.key
}

output "scope" {
  description = "The scope of the secret"
  value       = databricks_secret.this.scope
}




