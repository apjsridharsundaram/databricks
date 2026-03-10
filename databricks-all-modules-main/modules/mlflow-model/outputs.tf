output "id" {
  description = "The ID of the MLflow model"
  value       = databricks_mlflow_model.this.id
}

output "name" {
  description = "The name of the MLflow model"
  value       = databricks_mlflow_model.this.name
}

output "registered_model_id" {
  description = "The registered model ID"
  value       = databricks_mlflow_model.this.registered_model_id
}




