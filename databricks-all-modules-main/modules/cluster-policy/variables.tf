variable "name" {
  description = "Name of the cluster policy"
  type        = string
}

variable "definition" {
  description = "JSON-encoded policy definition"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the cluster policy"
  type        = string
  default     = null
}

variable "policy_family_id" {
  description = "ID of the policy family to inherit from"
  type        = string
  default     = null
}

variable "policy_family_definition_overrides" {
  description = "JSON-encoded overrides for policy family"
  type        = string
  default     = null
}

variable "max_clusters_per_user" {
  description = "Maximum number of clusters per user"
  type        = number
  default     = null
}




