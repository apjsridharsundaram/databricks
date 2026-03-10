variable "name" {
  description = "Name of the model serving endpoint"
  type        = string
}

variable "entity_name" {
  description = "Name of the model to serve"
  type        = string
}

variable "entity_version" {
  description = "Version of the model to serve"
  type        = string
}

variable "workload_size" {
  description = "Size of the serving workload (Small, Medium, Large)"
  type        = string
  default     = "Small"
}

variable "scale_to_zero_enabled" {
  description = "Enable scale to zero"
  type        = bool
  default     = true
}

variable "workload_type" {
  description = "Type of workload (CPU, GPU_SMALL, GPU_MEDIUM, GPU_LARGE)"
  type        = string
  default     = "CPU"
}

variable "environment_vars" {
  description = "Environment variables for the serving endpoint"
  type        = map(string)
  default     = {}
}

variable "traffic_routes" {
  description = "Traffic routing configuration for A/B testing"
  type = list(object({
    served_model_name  = string
    traffic_percentage = number
  }))
  default = null
}

variable "tags" {
  description = "Tags for the serving endpoint"
  type = list(object({
    key   = string
    value = string
  }))
  default = []
}




