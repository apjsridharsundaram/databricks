output "id" {
  description = "The ID of the VPC endpoint"
  value       = databricks_mws_vpc_endpoint.this.id
}

output "vpc_endpoint_id" {
  description = "The VPC endpoint ID"
  value       = databricks_mws_vpc_endpoint.this.vpc_endpoint_id
}

output "vpc_endpoint_name" {
  description = "The name of the VPC endpoint"
  value       = databricks_mws_vpc_endpoint.this.vpc_endpoint_name
}




