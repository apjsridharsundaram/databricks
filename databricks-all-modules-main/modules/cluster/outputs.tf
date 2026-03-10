output "id" {
  description = "The ID of the cluster"
  value       = databricks_cluster.this.id
}

output "cluster_id" {
  description = "The cluster ID"
  value       = databricks_cluster.this.cluster_id
}

output "cluster_name" {
  description = "The name of the cluster"
  value       = databricks_cluster.this.cluster_name
}

output "state" {
  description = "The current state of the cluster"
  value       = databricks_cluster.this.state
}

output "default_tags" {
  description = "Default tags applied to the cluster"
  value       = databricks_cluster.this.default_tags
}

output "url" {
  description = "URL of the cluster"
  value       = databricks_cluster.this.url
}




