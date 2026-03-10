output "id" {
  description = "The ID of the notebook"
  value       = databricks_notebook.this.id
}

output "path" {
  description = "The path to the notebook in the Databricks workspace"
  value       = databricks_notebook.this.path
}

output "object_id" {
  description = "The unique identifier for the notebook"
  value       = databricks_notebook.this.object_id
}

output "url" {
  description = "The URL to access the notebook"
  value       = databricks_notebook.this.url
}




