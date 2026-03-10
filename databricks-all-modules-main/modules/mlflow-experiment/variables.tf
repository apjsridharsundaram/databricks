variable "name" {
  description = "Name of the MLflow experiment"
  type        = string
}

variable "artifact_location" {
  description = "Location to store artifacts (S3 path or DBFS)"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the experiment"
  type        = string
  default     = null
}




