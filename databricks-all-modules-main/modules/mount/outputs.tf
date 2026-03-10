output "id" {
  description = "The ID of the mount"
  value       = databricks_mount.this.id
}

output "name" {
  description = "The name of the mount"
  value       = databricks_mount.this.name
}

output "source" {
  description = "The source of the mount"
  value       = databricks_mount.this.source
}




