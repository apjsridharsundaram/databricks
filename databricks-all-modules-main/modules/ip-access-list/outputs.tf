output "id" {
  description = "The ID of the IP access list"
  value       = databricks_ip_access_list.this.id
}

output "label" {
  description = "The label of the IP access list"
  value       = databricks_ip_access_list.this.label
}

output "list_type" {
  description = "The type of the IP access list"
  value       = databricks_ip_access_list.this.list_type
}




