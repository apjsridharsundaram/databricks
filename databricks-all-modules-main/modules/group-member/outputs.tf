output "id" {
  description = "The ID of the group membership"
  value       = databricks_group_member.this.id
}

output "group_id" {
  description = "The group ID"
  value       = databricks_group_member.this.group_id
}

output "member_id" {
  description = "The member ID"
  value       = databricks_group_member.this.member_id
}




