variable "authorization" {
  description = "The authorization type"
  type        = string
  default     = null
}

variable "cluster_id" {
  description = "ID of the cluster to set permissions on"
  type        = string
  default     = null
}

variable "cluster_policy_id" {
  description = "ID of the cluster policy to set permissions on"
  type        = string
  default     = null
}

variable "directory_path" {
  description = "Path of the directory to set permissions on"
  type        = string
  default     = null
}

variable "experiment_id" {
  description = "ID of the MLflow experiment to set permissions on"
  type        = string
  default     = null
}

variable "instance_pool_id" {
  description = "ID of the instance pool to set permissions on"
  type        = string
  default     = null
}

variable "job_id" {
  description = "ID of the job to set permissions on"
  type        = string
  default     = null
}

variable "notebook_path" {
  description = "Path of the notebook to set permissions on"
  type        = string
  default     = null
}

variable "pipeline_id" {
  description = "ID of the pipeline to set permissions on"
  type        = string
  default     = null
}

variable "registered_model_id" {
  description = "ID of the registered model to set permissions on"
  type        = string
  default     = null
}

variable "repo_id" {
  description = "ID of the repo to set permissions on"
  type        = string
  default     = null
}

variable "serving_endpoint_id" {
  description = "ID of the model serving endpoint to set permissions on"
  type        = string
  default     = null
}

variable "sql_alert_id" {
  description = "ID of the SQL alert to set permissions on"
  type        = string
  default     = null
}

variable "sql_dashboard_id" {
  description = "ID of the SQL dashboard to set permissions on"
  type        = string
  default     = null
}

variable "sql_endpoint_id" {
  description = "ID of the SQL endpoint/warehouse to set permissions on"
  type        = string
  default     = null
}

variable "sql_query_id" {
  description = "ID of the SQL query to set permissions on"
  type        = string
  default     = null
}

variable "workspace_file_path" {
  description = "Path of the workspace file to set permissions on"
  type        = string
  default     = null
}

variable "access_control_list" {
  description = "List of access control configurations"
  type = list(object({
    group_name             = optional(string)
    user_name              = optional(string)
    service_principal_name = optional(string)
    permission_level       = string
  }))
  default = []
}




