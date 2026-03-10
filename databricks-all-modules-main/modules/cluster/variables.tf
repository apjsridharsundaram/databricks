variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "spark_version" {
  description = "Runtime version of the cluster"
  type        = string
}

variable "node_type_id" {
  description = "The type of AWS instance for worker nodes"
  type        = string
}

variable "driver_node_type_id" {
  description = "The type of AWS instance for the driver node"
  type        = string
  default     = null
}

variable "num_workers" {
  description = "Number of worker nodes. Mutually exclusive with autoscale"
  type        = number
  default     = null
}

variable "autoscale" {
  description = "Autoscaling configuration"
  type = object({
    min_workers = number
    max_workers = number
  })
  default = null
}

variable "autotermination_minutes" {
  description = "Automatically terminate the cluster after being inactive for this time in minutes (SRA: 10 mins default)"
  type        = number
  default     = 10
  
  validation {
    condition     = var.autotermination_minutes > 0 && var.autotermination_minutes <= 10080
    error_message = "Autotermination must be between 1 and 10080 minutes (7 days). SRA default: 10 minutes."
  }
}

variable "spark_conf" {
  description = "Map of Spark configuration properties"
  type        = map(string)
  default     = {}
}

variable "custom_tags" {
  description = "Custom tags for cluster resources"
  type        = map(string)
  default     = {}
}

variable "spark_env_vars" {
  description = "Environment variables for Spark"
  type        = map(string)
  default     = {}
}

variable "enable_elastic_disk" {
  description = "Enable elastic disk on the cluster"
  type        = bool
  default     = true
}

variable "enable_local_disk_encryption" {
  description = "Enable local disk encryption (4.7: Recommended with AWS Nitro instances)"
  type        = bool
  default     = true
}

variable "data_security_mode" {
  description = "Data security mode (1.14: Use USER_ISOLATION for shared clusters, SINGLE_USER for dedicated)"
  type        = string
  default     = "USER_ISOLATION"
  
  validation {
    condition     = contains(["NONE", "SINGLE_USER", "USER_ISOLATION", "LEGACY_TABLE_ACL", "LEGACY_PASSTHROUGH", "LEGACY_SINGLE_USER"], var.data_security_mode)
    error_message = "Must be valid data security mode. Best practice: USER_ISOLATION for security (1.14)."
  }
}

variable "runtime_engine" {
  description = "Runtime engine (STANDARD or PHOTON)"
  type        = string
  default     = "STANDARD"
}

variable "instance_pool_id" {
  description = "The ID of the instance pool to use for worker nodes"
  type        = string
  default     = null
}

variable "driver_instance_pool_id" {
  description = "The ID of the instance pool to use for the driver node"
  type        = string
  default     = null
}

variable "policy_id" {
  description = "Identifier of the cluster policy"
  type        = string
  default     = null
}

variable "single_user_name" {
  description = "Single user name for single-user clusters"
  type        = string
  default     = null
}

variable "idempotency_token" {
  description = "Idempotency token for cluster creation"
  type        = string
  default     = null
}

variable "apply_policy_default_values" {
  description = "Whether to apply policy default values"
  type        = bool
  default     = true
}

variable "ssh_public_keys" {
  description = "List of SSH public keys to add to each node"
  type        = list(string)
  default     = []
}

variable "aws_attributes" {
  description = "AWS-specific attributes for the cluster (1.16, 4.7: Use instance_profile_arn and Nitro instances)"
  type = object({
    zone_id                = optional(string)
    availability           = optional(string, "SPOT_WITH_FALLBACK")
    spot_bid_price_percent = optional(number, 100)
    instance_profile_arn   = optional(string)  # Required for secure S3 access (1.16)
    first_on_demand        = optional(number, 1)
    ebs_volume_type        = optional(string, "GENERAL_PURPOSE_SSD")
    ebs_volume_count       = optional(number, 1)
    ebs_volume_size        = optional(number, 100)
    ebs_volume_iops        = optional(number)
    ebs_volume_throughput  = optional(number)
  })
  default = null
  
  validation {
    condition     = var.aws_attributes == null || try(var.aws_attributes.instance_profile_arn, null) != null
    error_message = "instance_profile_arn is required for secure S3 access (Best Practice 1.16)."
  }
}

variable "init_scripts" {
  description = "List of init scripts"
  type = list(object({
    dbfs = optional(object({
      destination = string
    }))
    s3 = optional(object({
      destination = string
      region      = optional(string)
      endpoint    = optional(string)
    }))
    volumes = optional(object({
      destination = string
    }))
    workspace = optional(object({
      destination = string
    }))
  }))
  default = []
}

variable "libraries" {
  description = "List of libraries to install on the cluster"
  type = list(object({
    jar = optional(string)
    egg = optional(string)
    whl = optional(string)
    pypi = optional(object({
      package = string
      repo    = optional(string)
    }))
    maven = optional(object({
      coordinates = string
      repo        = optional(string)
      exclusions  = optional(list(string))
    }))
    cran = optional(object({
      package = string
      repo    = optional(string)
    }))
  }))
  default = []
}

variable "cluster_log_conf" {
  description = "Cluster log configuration"
  type = object({
    dbfs = optional(object({
      destination = string
    }))
    s3 = optional(object({
      destination       = string
      region            = optional(string)
      endpoint          = optional(string)
      enable_encryption = optional(bool)
      encryption_type   = optional(string)
      kms_key           = optional(string)
      canned_acl        = optional(string)
    }))
  })
  default = null
}

variable "docker_image" {
  description = "Docker image configuration"
  type = object({
    url = string
    basic_auth = optional(object({
      username = string
      password = string
    }))
  })
  default = null
}

variable "workload_type" {
  description = "Workload type configuration"
  type = object({
    clients = optional(object({
      jobs      = optional(bool)
      notebooks = optional(bool)
    }))
  })
  default = null
}

variable "enable_enhanced_security" {
  description = "Enable enhanced security Spark configurations (Recommended for production)"
  type        = bool
  default     = true
}

variable "allowed_languages" {
  description = "Allowed languages for notebooks (python, sql, scala, r)"
  type        = string
  default     = "python,sql,scala"
  
  validation {
    condition     = can(regex("^(python|sql|scala|r)(,(python|sql|scala|r))*$", var.allowed_languages))
    error_message = "Must be comma-separated list of: python, sql, scala, r."
  }
}


