variable "name" {
  description = "Name of the table"
  type        = string
}

variable "catalog_name" {
  description = "Name of the parent catalog"
  type        = string
}

variable "schema_name" {
  description = "Name of the parent schema"
  type        = string
}

variable "table_type" {
  description = "Type of table (MANAGED, EXTERNAL, VIEW)"
  type        = string
  default     = "MANAGED"
}

variable "data_source_format" {
  description = "Data source format (DELTA, CSV, JSON, PARQUET, etc.)"
  type        = string
  default     = "DELTA"
}

variable "storage_location" {
  description = "Storage location for external tables"
  type        = string
  default     = null
}

variable "storage_credential_name" {
  description = "Storage credential name for external tables"
  type        = string
  default     = null
}

variable "view_definition" {
  description = "SQL definition for views"
  type        = string
  default     = null
}

variable "comment" {
  description = "Comment/description for the table"
  type        = string
  default     = null
}

variable "properties" {
  description = "Table properties"
  type        = map(string)
  default     = {}
}

variable "owner" {
  description = "Owner of the table"
  type        = string
  default     = null
}

variable "warehouse_id" {
  description = "SQL warehouse ID for view creation"
  type        = string
  default     = null
}

variable "columns" {
  description = "List of table columns"
  type = list(object({
    name     = string
    type     = string
    comment  = optional(string)
    nullable = optional(bool, true)
  }))
  default = []
}

variable "partitions" {
  description = "List of partition columns"
  type = list(object({
    partition_column_name = string
  }))
  default = []
}

variable "cluster_by" {
  description = "Cluster by configuration"
  type = object({
    columns = list(string)
  })
  default = null
}




