resource "databricks_mlflow_experiment" "this" {
  name              = var.name
  artifact_location = var.artifact_location
  description       = var.description
}




