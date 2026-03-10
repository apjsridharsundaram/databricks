resource "databricks_mws_credentials" "this" {
  account_id       = var.account_id
  credentials_name = var.credentials_name
  role_arn         = var.role_arn
}




