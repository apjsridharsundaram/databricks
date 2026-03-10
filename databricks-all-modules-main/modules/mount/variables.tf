variable "name" {
  description = "Name/path of the mount point (e.g., /mnt/my-mount)"
  type        = string
}

variable "s3_config" {
  description = "S3 configuration for the mount"
  type = object({
    bucket_name      = string
    instance_profile = optional(string)
  })
  default = null
}

variable "cluster_id" {
  description = "Cluster ID to use for mounting"
  type        = string
  default     = null
}

variable "resource_id" {
  description = "Resource ID"
  type        = string
  default     = null
}

variable "encryption_type" {
  description = "Encryption type (e.g., sse-s3, sse-kms)"
  type        = string
  default     = null
}

variable "uri" {
  description = "URI of the storage location"
  type        = string
  default     = null
}




