# Example: Basic Catalog Creation

terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.0.0"
    }
  }
}

# Create a catalog with ISOLATED mode (SRA best practice)
module "catalog" {
  source = "../../"

  name    = "example_catalog"
  comment = "Example catalog with security best practices"
  
  # SRA: ISOLATED mode restricts catalog to specific workspace bindings
  isolation_mode = "ISOLATED"
  
  properties = {
    environment = "production"
    team        = "data-engineering"
  }
  
  owner = "account users"
  
  force_destroy = false  # Set to true for testing/development
}

output "catalog_id" {
  description = "The ID of the created catalog"
  value       = module.catalog.id
}

output "catalog_name" {
  description = "The name of the created catalog"
  value       = module.catalog.name
}

output "metastore_id" {
  description = "The metastore ID"
  value       = module.catalog.metastore_id
}


