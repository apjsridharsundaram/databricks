variable "url" {
  description = "URL of the Git repository (5.5: Only use trusted, approved repositories. 3.7: Restrict to trusted networks)"
  type        = string
  
  validation {
    condition     = can(regex("^https://", var.url))
    error_message = "Repository URL must use HTTPS protocol for security."
  }
}

variable "path" {
  description = "Path where the repo will be created in Databricks workspace"
  type        = string
  default     = null
}

variable "git_provider" {
  description = "Git provider (gitHub, gitHubEnterprise, bitbucketCloud, bitbucketServer, azureDevOpsServices, gitLab, gitLabEnterpriseEdition, awsCodeCommit)"
  type        = string
  default     = null
}

variable "branch" {
  description = "Branch to checkout"
  type        = string
  default     = null
}

variable "tag" {
  description = "Tag to checkout"
  type        = string
  default     = null
}

variable "commit_hash" {
  description = "Specific commit hash to checkout"
  type        = string
  default     = null
}


