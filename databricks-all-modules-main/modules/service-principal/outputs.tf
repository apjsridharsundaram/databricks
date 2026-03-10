output "id" {
  description = "The ID of the service principal"
  value       = databricks_service_principal.this.id
}

output "application_id" {
  description = "The application ID of the service principal"
  value       = databricks_service_principal.this.application_id
}

output "display_name" {
  description = "The display name of the service principal"
  value       = databricks_service_principal.this.display_name
}

output "acl_principal_id" {
  description = "The ACL principal ID of the service principal"
  value       = databricks_service_principal.this.acl_principal_id
}




