# =============================================================================
# Required Variables
# =============================================================================

variable "databricks_account_id" {
  description = "Databricks account ID"
  type        = string
}

variable "workspace_name" {
  description = "Name prefix for the workspace and all resources"
  type        = string
}

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-west-2"
}

# =============================================================================
# Network Configuration
# =============================================================================

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets_cidr" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets_cidr" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "single_nat_gateway" {
  description = "Use single NAT gateway (cost optimization)"
  type        = bool
  default     = true
}

variable "one_nat_gateway_per_az" {
  description = "Create one NAT gateway per AZ (high availability)"
  type        = bool
  default     = false
}

# =============================================================================
# PrivateLink Configuration
# =============================================================================

variable "enable_private_link" {
  description = "Enable AWS PrivateLink for workspace connectivity (SRA recommended)"
  type        = bool
  default     = false
}

variable "privatelink_subnets_cidr" {
  description = "CIDR blocks for PrivateLink (intra) subnets. Required when enable_private_link = true."
  type        = list(string)
  default     = ["10.0.201.0/24", "10.0.202.0/24"]
}

variable "private_access_level" {
  description = "Private access level for the workspace (ACCOUNT or ENDPOINT)"
  type        = string
  default     = "ACCOUNT"

  validation {
    condition     = contains(["ACCOUNT", "ENDPOINT"], var.private_access_level)
    error_message = "Private access level must be ACCOUNT or ENDPOINT."
  }
}

variable "public_access_enabled" {
  description = "Whether public access is enabled for the workspace when PrivateLink is active"
  type        = bool
  default     = true
}

variable "sg_egress_ports" {
  description = "Egress ports for workspace SG to VPC CIDR (Databricks control plane ports)"
  type        = list(number)
  default     = [443, 2443, 5432, 6666, 8443, 8444, 8445, 8446, 8447, 8448, 8449, 8450, 8451]
}

# =============================================================================
# Security Configuration
# =============================================================================

variable "enable_cmk" {
  description = "Enable customer-managed keys for encryption (SRA recommended)"
  type        = bool
  default     = true
}

variable "pricing_tier" {
  description = "Workspace pricing tier (ENTERPRISE required for Unity Catalog)"
  type        = string
  default     = "ENTERPRISE"

  validation {
    condition     = contains(["STANDARD", "PREMIUM", "ENTERPRISE"], var.pricing_tier)
    error_message = "Pricing tier must be STANDARD, PREMIUM, or ENTERPRISE."
  }
}

variable "allowed_ip_addresses" {
  description = "List of allowed IP addresses/CIDR blocks for workspace access"
  type        = list(string)
  default     = []
}

variable "ip_access_list_label" {
  description = "Label for IP access list"
  type        = string
  default     = "corporate-network"
}

# =============================================================================
# Unity Catalog Configuration
# =============================================================================

variable "create_metastore" {
  description = "Create Unity Catalog metastore"
  type        = bool
  default     = true
}

variable "metastore_owner" {
  description = "Owner of the metastore"
  type        = string
  default     = "account users"
}

variable "create_default_catalog" {
  description = "Create default catalog"
  type        = bool
  default     = true
}

variable "default_catalog_name" {
  description = "Name of the default catalog"
  type        = string
  default     = "main"
}

variable "catalog_owner" {
  description = "Owner of the default catalog"
  type        = string
  default     = "account users"
}

variable "unity_catalog_iam_arn" {
  description = "Databricks Unity Catalog master role ARN for trust policy"
  type        = string
  default     = "arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL"
}

variable "catalog_properties" {
  description = "Properties/tags for the default catalog"
  type        = map(string)
  default     = {}
}

variable "catalog_isolation_mode" {
  description = "Catalog isolation mode (ISOLATED or OPEN). ISOLATED recommended for security"
  type        = string
  default     = "ISOLATED"

  validation {
    condition     = contains(["ISOLATED", "OPEN"], var.catalog_isolation_mode)
    error_message = "Catalog isolation mode must be ISOLATED or OPEN."
  }
}

# =============================================================================
# Medallion Architecture
# =============================================================================

variable "create_bronze_schema" {
  description = "Create bronze schema in default catalog (for medallion architecture)"
  type        = bool
  default     = false
}

variable "create_silver_schema" {
  description = "Create silver schema in default catalog (for medallion architecture)"
  type        = bool
  default     = false
}

variable "create_gold_schema" {
  description = "Create gold schema in default catalog (for medallion architecture)"
  type        = bool
  default     = false
}

# =============================================================================
# Workspace Security Configuration
# =============================================================================

variable "configure_workspace_security" {
  description = "Apply workspace security settings (data exfiltration prevention)"
  type        = bool
  default     = true
}

variable "create_cluster_policy" {
  description = "Create secure cluster policy"
  type        = bool
  default     = true
}

variable "cluster_policy_name" {
  description = "Name of the cluster policy"
  type        = string
  default     = "secure-production-policy"
}

variable "max_clusters_per_user" {
  description = "Maximum clusters per user (null for unlimited)"
  type        = number
  default     = null
}

variable "min_autotermination_minutes" {
  description = "Minimum autotermination minutes for cluster policy"
  type        = number
  default     = 10
}

variable "max_autotermination_minutes" {
  description = "Maximum autotermination minutes for cluster policy (10080 = 7 days)"
  type        = number
  default     = 10080
}

variable "allowed_instance_types" {
  description = "List of allowed instance types (empty = allow ALL types)"
  type        = list(string)
  default     = []
}

variable "allowed_spark_versions" {
  description = "Allowed Spark versions regex pattern (null = allow all standard versions)"
  type        = string
  default     = null
}

variable "create_ip_access_list" {
  description = "Create IP access list"
  type        = bool
  default     = true
}

variable "enable_web_terminal" {
  description = "Enable web terminal in workspace (SRA: false)"
  type        = bool
  default     = false
}

variable "max_token_lifetime_days" {
  description = "Maximum token lifetime in days (0 = no limit)"
  type        = number
  default     = 90
}

variable "create_admin_group" {
  description = "Create admin group"
  type        = bool
  default     = true
}

variable "admin_group_name" {
  description = "Name of the admin group"
  type        = string
  default     = "workspace-admins"
}

variable "create_data_engineers_group" {
  description = "Create data engineers group"
  type        = bool
  default     = false
}

variable "data_engineers_group_name" {
  description = "Name of data engineers group"
  type        = string
  default     = "data-engineers"
}

variable "create_data_scientists_group" {
  description = "Create data scientists group"
  type        = bool
  default     = false
}

variable "data_scientists_group_name" {
  description = "Name of data scientists group"
  type        = string
  default     = "data-scientists"
}

# =============================================================================
# Additional Configuration
# =============================================================================

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "Allow force destroy of resources (set to true for testing)"
  type        = bool
  default     = false
}

# =============================================================================
# Deployment Configuration
# =============================================================================

variable "deployment_name" {
  description = "Deployment name for the workspace URL prefix. Must be enabled by a Databricks representative."
  type        = string
  default     = null
  nullable    = true
}

# =============================================================================
# GovCloud Configuration
# =============================================================================

variable "databricks_gov_shard" {
  description = "Databricks GovCloud shard type. Only applicable for us-gov-west-1 region."
  type        = string
  default     = null

  validation {
    condition     = var.databricks_gov_shard == null || can(contains(["civilian", "dod"], var.databricks_gov_shard))
    error_message = "Allowed values: null, civilian, dod."
  }
}

# =============================================================================
# KMS Configuration
# =============================================================================

variable "cmk_admin_arn" {
  description = "ARN of the CMK admin principal. Defaults to the AWS account root if not specified."
  type        = string
  default     = null
}

variable "root_bucket_versioning" {
  description = "Enable versioning on the root storage bucket. SRA recommends disabled."
  type        = bool
  default     = false
}

# =============================================================================
# Network Connectivity Configuration (NCC)
# =============================================================================

variable "enable_ncc" {
  description = "Enable Network Connectivity Configuration for serverless compute egress control (SRA recommended)"
  type        = bool
  default     = true
}


# =============================================================================
# Audit Log Delivery
# =============================================================================

variable "enable_audit_logs" {
  description = "Enable audit log delivery to S3 (SRA recommended)"
  type        = bool
  default     = true
}

# =============================================================================
# Compliance Security Profile
# =============================================================================

variable "enable_csp" {
  description = "Enable Compliance Security Profile on the workspace (SRA recommended for regulated workloads)"
  type        = bool
  default     = false
}

variable "compliance_standards" {
  description = "List of compliance standards for CSP (e.g., HIPAA, PCI_DSS, FEDRAMP_MODERATE)"
  type        = list(string)
  default     = null
  nullable    = true
}


