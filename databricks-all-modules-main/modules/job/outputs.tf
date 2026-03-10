output "id" {
  description = "The ID of the job"
  value       = databricks_job.this.id
}

output "job_id" {
  description = "The job ID"
  value       = databricks_job.this.id
}

output "name" {
  description = "The name of the job"
  value       = databricks_job.this.name
}

output "url" {
  description = "The URL to access the job"
  value       = databricks_job.this.url
}




