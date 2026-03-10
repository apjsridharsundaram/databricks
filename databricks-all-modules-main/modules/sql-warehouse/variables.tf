variable "name" {
  description = "Name of the SQL warehouse"
  type        = string
}

variable "cluster_size" {
  description = "Size of the cluster (2X-Small, X-Small, Small, Medium, Large, X-Large, 2X-Large, 3X-Large, 4X-Large)"
  type        = string
}

variable "max_num_clusters" {
  description = "Maximum number of clusters"
  type        = number
  default     = 1
}

variable "min_num_clusters" {
  description = "Minimum number of clusters"
  type        = number
  default     = 1
}

variable "auto_stop_mins" {
  description = "Auto-stop time in minutes"
  type        = number
  default     = 120
}

variable "enable_photon" {
  description = "Enable Photon acceleration"
  type        = bool
  default     = true
}

variable "enable_serverless_compute" {
  description = "Enable serverless compute (1.14: Recommended for automatic user isolation)"
  type        = bool
  default     = true
}

variable "spot_instance_policy" {
  description = "Spot instance policy (COST_OPTIMIZED, RELIABILITY_OPTIMIZED)"
  type        = string
  default     = "COST_OPTIMIZED"
}

variable "warehouse_type" {
  description = "Warehouse type (PRO, CLASSIC, TYPE_UNSPECIFIED)"
  type        = string
  default     = "PRO"
}

variable "channel" {
  description = "Channel configuration"
  type = object({
    name = string
  })
  default = null
}

variable "tags" {
  description = "Custom tags for the warehouse"
  type = object({
    custom_tags = map(string)
  })
  default = null
}


