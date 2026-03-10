output "id" {
  description = "The ID of the repo"
  value       = databricks_repo.this.id
}

output "path" {
  description = "The path of the repo"
  value       = databricks_repo.this.path
}

output "workspace_path" {
  description = "The workspace path of the repo"
  value       = databricks_repo.this.workspace_path
}

output "url" {
  description = "The URL of the repo"
  value       = databricks_repo.this.url
}




