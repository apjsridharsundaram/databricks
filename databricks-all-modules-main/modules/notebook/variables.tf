variable "path" {
  description = "The path to the notebook in the Databricks workspace"
  type        = string
}

variable "language" {
  description = "The language of the notebook (PYTHON, SCALA, SQL, or R)"
  type        = string

  validation {
    condition     = contains(["PYTHON", "SCALA", "SQL", "R"], var.language)
    error_message = "Language must be PYTHON, SCALA, SQL, or R"
  }
}

variable "format" {
  description = "The format of the notebook (SOURCE, HTML, JUPYTER, or DBC)"
  type        = string
  default     = "SOURCE"

  validation {
    condition     = contains(["SOURCE", "HTML", "JUPYTER", "DBC"], var.format)
    error_message = "Format must be SOURCE, HTML, JUPYTER, or DBC"
  }
}

variable "content_base64" {
  description = "The base64-encoded content of the notebook"
  type        = string
  default     = null
}

variable "notebook_source" {
  description = "Path to the notebook file on the local filesystem"
  type        = string
  default     = null
}

variable "object_id" {
  description = "Unique identifier for the notebook"
  type        = string
  default     = null
}




