# =============================================================================
# Workspace Outputs
# =============================================================================

output "workspace_id" {
  description = "Databricks workspace ID"
  value       = module.workspace.workspace_id
}

output "workspace_url" {
  description = "Databricks workspace URL"
  value       = module.workspace.workspace_url
}

output "deployment_name" {
  description = "Workspace deployment name"
  value       = module.workspace.deployment_name
}

# =============================================================================
# AWS Infrastructure Outputs
# =============================================================================

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = module.vpc.natgw_ids
}

output "security_group_id" {
  description = "Databricks workspace security group ID"
  value       = module.sg_workspace.security_group_id
}

output "s3_bucket_name" {
  description = "Workspace storage S3 bucket name"
  value       = module.s3_bucket.s3_bucket_id
}

output "s3_bucket_arn" {
  description = "Workspace storage S3 bucket ARN"
  value       = module.s3_bucket.s3_bucket_arn
}

output "cross_account_role_arn" {
  description = "Cross-account IAM role ARN"
  value       = module.iam_assumable_role_databricks.iam_role_arn
}

# =============================================================================
# Security Outputs
# =============================================================================

output "managed_services_cmk_id" {
  description = "Managed services customer-managed key ID"
  value       = var.enable_cmk ? databricks_mws_customer_managed_keys.managed_services[0].customer_managed_key_id : null
}

output "storage_cmk_id" {
  description = "Storage customer-managed key ID"
  value       = var.enable_cmk ? databricks_mws_customer_managed_keys.workspace_storage[0].customer_managed_key_id : null
}

output "managed_services_kms_key_arn" {
  description = "Managed services KMS key ARN"
  value       = var.enable_cmk ? module.kms_managed_services[0].key_arn : null
}

output "storage_kms_key_arn" {
  description = "Storage KMS key ARN"
  value       = var.enable_cmk ? module.kms_workspace_storage[0].key_arn : null
}

# =============================================================================
# Unity Catalog Outputs
# =============================================================================

output "metastore_id" {
  description = "Unity Catalog metastore ID"
  value       = var.create_metastore ? module.metastore[0].id : null
}

output "default_catalog_id" {
  description = "Default catalog ID"
  value       = var.create_default_catalog ? databricks_catalog.default[0].id : null
}

output "default_catalog_name" {
  description = "Default catalog name"
  value       = var.create_default_catalog ? databricks_catalog.default[0].name : null
}

# =============================================================================
# Additional Outputs
# =============================================================================

output "admin_group_id" {
  description = "Admin group ID"
  value       = var.create_admin_group ? module.admin_group[0].id : null
}

output "data_engineers_group_id" {
  description = "Data engineers group ID"
  value       = var.create_data_engineers_group ? module.data_engineers_group[0].id : null
}

output "data_scientists_group_id" {
  description = "Data scientists group ID"
  value       = var.create_data_scientists_group ? module.data_scientists_group[0].id : null
}

output "bronze_schema_id" {
  description = "Bronze schema ID (medallion architecture)"
  value       = var.create_default_catalog && var.create_bronze_schema ? module.schema_bronze[0].id : null
}

output "silver_schema_id" {
  description = "Silver schema ID (medallion architecture)"
  value       = var.create_default_catalog && var.create_silver_schema ? module.schema_silver[0].id : null
}

output "gold_schema_id" {
  description = "Gold schema ID (medallion architecture)"
  value       = var.create_default_catalog && var.create_gold_schema ? module.schema_gold[0].id : null
}

output "secure_cluster_policy_id" {
  description = "Secure cluster policy ID"
  value       = var.create_cluster_policy ? module.secure_cluster_policy[0].policy_id : null
}

output "ip_access_list_id" {
  description = "IP access list ID"
  value       = var.create_ip_access_list && length(var.allowed_ip_addresses) > 0 ? module.ip_access_list[0].id : null
}

# =============================================================================
# PrivateLink Outputs
# =============================================================================

output "private_access_settings_id" {
  description = "Private access settings ID"
  value       = var.enable_private_link ? databricks_mws_private_access_settings.this[0].private_access_settings_id : null
}

output "rest_vpc_endpoint_id" {
  description = "AWS VPC endpoint ID for Databricks REST API"
  value       = var.enable_private_link ? module.vpc_endpoints[0].endpoints["backend_rest"].id : null
}

output "relay_vpc_endpoint_id" {
  description = "AWS VPC endpoint ID for Databricks SCC relay"
  value       = var.enable_private_link ? module.vpc_endpoints[0].endpoints["backend_relay"].id : null
}

output "privatelink_security_group_id" {
  description = "PrivateLink security group ID"
  value       = var.enable_private_link ? module.sg_privatelink[0].security_group_id : null
}

output "intra_subnet_ids" {
  description = "PrivateLink (intra) subnet IDs"
  value       = var.enable_private_link ? module.vpc.intra_subnets : []
}

# =============================================================================
# Network Connectivity Configuration Outputs
# =============================================================================

output "ncc_id" {
  description = "Network Connectivity Configuration ID"
  value       = var.enable_ncc ? databricks_mws_network_connectivity_config.ncc[0].network_connectivity_config_id : null
}


# =============================================================================
# Audit Log Delivery Outputs
# =============================================================================

output "audit_log_s3_bucket_name" {
  description = "Audit log delivery S3 bucket name"
  value       = var.enable_audit_logs ? module.s3_audit_log_delivery[0].s3_bucket_id : null
}

output "audit_log_delivery_config_id" {
  description = "Audit log delivery configuration ID"
  value       = var.enable_audit_logs ? databricks_mws_log_delivery.audit_logs[0].config_id : null
}

# =============================================================================
# Compliance Security Profile Output
# =============================================================================

output "csp_enabled" {
  description = "Whether Compliance Security Profile is enabled"
  value       = var.enable_csp
}

# =============================================================================
# Summary Output
# =============================================================================

output "workspace_info" {
  description = "Complete workspace information"
  value = {
    workspace_id     = module.workspace.workspace_id
    workspace_url    = module.workspace.workspace_url
    aws_region       = var.aws_region
    vpc_id           = module.vpc.vpc_id
    s3_bucket        = module.s3_bucket.s3_bucket_id
    cmk_enabled      = var.enable_cmk
    private_link     = var.enable_private_link
    uc_enabled       = var.create_metastore
    catalog_name     = var.create_default_catalog ? databricks_catalog.default[0].name : null
    ncc_enabled      = var.enable_ncc
    audit_logs       = var.enable_audit_logs
    csp_enabled      = var.enable_csp
    medallion_schemas = {
      bronze = var.create_bronze_schema
      silver = var.create_silver_schema
      gold   = var.create_gold_schema
    }
    groups = {
      admin           = var.create_admin_group
      data_engineers  = var.create_data_engineers_group
      data_scientists = var.create_data_scientists_group
    }
  }
}
