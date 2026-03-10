output "id" {
  description = "The ID of the pipeline"
  value       = databricks_pipeline.this.id
}

output "name" {
  description = "The name of the pipeline"
  value       = databricks_pipeline.this.name
}

output "url" {
  description = "The URL to access the pipeline"
  value       = databricks_pipeline.this.url
}




