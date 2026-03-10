variable "name" {
  description = "Name of the SQL query"
  type        = string
}

variable "data_source_id" {
  description = "ID of the SQL warehouse (data source)"
  type        = string
}

variable "description" {
  description = "Description of the query"
  type        = string
  default     = null
}

variable "query" {
  description = "SQL query text"
  type        = string
}

variable "parent" {
  description = "Parent folder path"
  type        = string
  default     = null
}

variable "run_as_role" {
  description = "Run as role (viewer or owner)"
  type        = string
  default     = "viewer"
}

variable "tags" {
  description = "Tags for the query"
  type        = map(string)
  default     = {}
}

variable "parameters" {
  description = "Query parameters"
  type        = list(any)
  default     = []
}

variable "schedule" {
  description = "Query schedule configuration. Not supported by databricks_query resource; retained for variable compatibility only."
  type = object({
    interval_seconds = number
  })
  default = null
}




