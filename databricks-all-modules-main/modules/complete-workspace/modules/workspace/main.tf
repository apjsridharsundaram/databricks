resource "databricks_mws_workspaces" "this" {
  workspace_name  = var.workspace_name
  account_id      = var.account_id
  aws_region      = var.aws_region
  deployment_name = var.deployment_name

  credentials_id           = var.credentials_id
  storage_configuration_id = var.storage_configuration_id
  network_id               = var.network_id

  dynamic "token" {
    for_each = var.token_config != null ? [var.token_config] : []
    content {
      comment          = token.value.comment
      lifetime_seconds = token.value.lifetime_seconds
    }
  }

  custom_tags                              = var.custom_tags
  pricing_tier                             = var.pricing_tier
  private_access_settings_id               = var.private_access_settings_id
  storage_customer_managed_key_id          = var.storage_customer_managed_key_id
  managed_services_customer_managed_key_id = var.managed_services_customer_managed_key_id
}
