resource "databricks_mws_networks" "this" {
  account_id         = var.account_id
  network_name       = var.network_name
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
  
  vpc_endpoints {
    dataplane_relay = var.vpc_endpoints.dataplane_relay
    rest_api        = var.vpc_endpoints.rest_api
  }
}




