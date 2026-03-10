variable "name" {
  description = "Name of the SQL dashboard"
  type        = string
}

variable "parent" {
  description = "Parent folder path"
  type        = string
  default     = "folders/Shared"
}

variable "warehouse_id" {
  description = "ID of the SQL warehouse used by the dashboard"
  type        = string
}

variable "tags" {
  description = "Tags for the dashboard"
  type        = map(string)
  default     = {}
}




