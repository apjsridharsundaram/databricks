variable "cluster_id" {
  description = "ID of the cluster to install the library on"
  type        = string
}

variable "jar" {
  description = "Path to JAR file (DBFS, S3, or Workspace)"
  type        = string
  default     = null
}

variable "egg" {
  description = "Path to Python egg file"
  type        = string
  default     = null
}

variable "whl" {
  description = "Path to Python wheel file"
  type        = string
  default     = null
}

variable "pypi" {
  description = "PyPI package configuration"
  type = object({
    package = string
    repo    = optional(string)
  })
  default = null
}

variable "maven" {
  description = "Maven package configuration"
  type = object({
    coordinates = string
    repo        = optional(string)
    exclusions  = optional(list(string))
  })
  default = null
}

variable "cran" {
  description = "CRAN package configuration"
  type = object({
    package = string
    repo    = optional(string)
  })
  default = null
}




