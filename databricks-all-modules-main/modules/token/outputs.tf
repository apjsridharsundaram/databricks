output "id" {
  description = "The ID of the token"
  value       = databricks_token.this.id
}

output "token_value" {
  description = "The token value"
  value       = databricks_token.this.token_value
  sensitive   = true
}




