output "id" {
  description = "The ID of the model serving endpoint"
  value       = databricks_model_serving.this.id
}

output "name" {
  description = "The name of the model serving endpoint"
  value       = databricks_model_serving.this.name
}

output "serving_endpoint_id" {
  description = "The serving endpoint ID"
  value       = databricks_model_serving.this.serving_endpoint_id
}




