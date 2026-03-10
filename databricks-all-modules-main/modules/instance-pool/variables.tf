variable "instance_pool_name" {
  description = "Name of the instance pool"
  type        = string
}

variable "min_idle_instances" {
  description = "Minimum number of idle instances"
  type        = number
  default     = 0
}

variable "max_capacity" {
  description = "Maximum capacity of the instance pool"
  type        = number
  default     = null
}

variable "node_type_id" {
  description = "AWS instance type for the pool"
  type        = string
}

variable "custom_tags" {
  description = "Custom tags for instances"
  type        = map(string)
  default     = {}
}

variable "idle_instance_autotermination_minutes" {
  description = "Idle instance auto-termination in minutes"
  type        = number
  default     = 60
}

variable "enable_elastic_disk" {
  description = "Enable elastic disk"
  type        = bool
  default     = true
}

variable "preloaded_spark_versions" {
  description = "List of Spark versions to preload"
  type        = list(string)
  default     = []
}

variable "disk_spec" {
  description = "Disk specification"
  type = object({
    disk_type = optional(object({
      ebs_volume_type = optional(string)
      # throughput and iops removed - not supported in current API
    }))
    disk_count = optional(number)
    disk_size  = optional(number)
  })
  default = null
}

variable "aws_attributes" {
  description = "AWS-specific attributes"
  type = object({
    availability           = optional(string)
    zone_id                = optional(string)
    spot_bid_price_percent = optional(number)
  })
  default = null
}

variable "preloaded_docker_images" {
  description = "List of preloaded Docker images"
  type = list(object({
    url = string
    basic_auth = optional(object({
      username = string
      password = string
    }))
  }))
  default = []
}




