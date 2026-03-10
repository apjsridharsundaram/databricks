variable "name" {
  description = "Name of the MLflow registered model"
  type        = string
}

variable "description" {
  description = "Description of the model"
  type        = string
  default     = null
}

variable "tags" {
  description = "List of tags for the model"
  type = list(object({
    key   = string
    value = string
  }))
  default = []
}




