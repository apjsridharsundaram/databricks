output "id" {
  description = "The ID of the group"
  value       = databricks_group.this.id
}

output "display_name" {
  description = "The display name of the group"
  value       = databricks_group.this.display_name
}

output "acl_principal_id" {
  description = "The ACL principal ID of the group"
  value       = databricks_group.this.acl_principal_id
}




