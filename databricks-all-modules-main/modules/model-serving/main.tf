resource "databricks_model_serving" "this" {
  name = var.name
  
  config {
    served_entities {
      entity_name           = var.entity_name
      entity_version        = var.entity_version
      workload_size         = var.workload_size
      scale_to_zero_enabled = var.scale_to_zero_enabled
      workload_type         = var.workload_type
      environment_vars      = length(var.environment_vars) > 0 ? var.environment_vars : null
    }
    
    dynamic "traffic_config" {
      for_each = var.traffic_routes != null ? [1] : []
      content {
        dynamic "routes" {
          for_each = var.traffic_routes
          content {
            served_model_name   = routes.value.served_model_name
            traffic_percentage  = routes.value.traffic_percentage
          }
        }
      }
    }
  }
  
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}




