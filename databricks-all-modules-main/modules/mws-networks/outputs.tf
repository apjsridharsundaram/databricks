output "id" {
  description = "The ID of the network configuration"
  value       = databricks_mws_networks.this.id
}

output "network_id" {
  description = "The network ID"
  value       = databricks_mws_networks.this.network_id
}

output "network_name" {
  description = "The name of the network configuration"
  value       = databricks_mws_networks.this.network_name
}

output "vpc_id" {
  description = "The VPC ID"
  value       = databricks_mws_networks.this.vpc_id
}




