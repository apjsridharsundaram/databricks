variable "name" {
  description = "Name of the pipeline"
  type        = string
}

variable "storage" {
  description = "Storage location for the pipeline"
  type        = string
  default     = null
}

variable "target" {
  description = "Target schema for the pipeline"
  type        = string
  default     = null
}

variable "catalog" {
  description = "Target catalog for Unity Catalog pipelines"
  type        = string
  default     = null
}

variable "clusters" {
  description = "List of cluster configurations"
  type        = list(any)
  default     = []
}

variable "configuration" {
  description = "Pipeline configuration settings"
  type        = map(string)
  default     = {}
}

variable "continuous" {
  description = "Whether the pipeline runs continuously"
  type        = bool
  default     = false
}

variable "development" {
  description = "Whether this is a development pipeline"
  type        = bool
  default     = false
}

variable "edition" {
  description = "Pipeline edition (CORE, PRO, ADVANCED)"
  type        = string
  default     = "ADVANCED"
}

variable "channel" {
  description = "Release channel (CURRENT or PREVIEW)"
  type        = string
  default     = "CURRENT"
}

variable "photon" {
  description = "Enable Photon acceleration"
  type        = bool
  default     = true
}

variable "allow_duplicate_names" {
  description = "Allow duplicate pipeline names"
  type        = bool
  default     = false
}

variable "libraries" {
  description = "List of libraries"
  type        = list(any)
  default     = []
}

variable "filters" {
  description = "Filters for selective refresh"
  type = object({
    include = optional(list(string))
    exclude = optional(list(string))
  })
  default = null
}

variable "notifications" {
  description = "List of notification configurations"
  type = list(object({
    email_recipients = list(string)
    alerts           = list(string)
  }))
  default = []
}





