output "id" {
  description = "The ID of the credentials configuration"
  value       = databricks_mws_credentials.this.id
}

output "credentials_id" {
  description = "The credentials ID"
  value       = databricks_mws_credentials.this.credentials_id
}

output "credentials_name" {
  description = "The name of the credentials"
  value       = databricks_mws_credentials.this.credentials_name
}

output "external_id" {
  description = "The external ID for the trust relationship"
  value       = databricks_mws_credentials.this.external_id
}




