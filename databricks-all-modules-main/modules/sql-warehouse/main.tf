resource "databricks_sql_endpoint" "this" {
  name             = var.name
  cluster_size     = var.cluster_size
  max_num_clusters = var.max_num_clusters
  min_num_clusters = var.min_num_clusters
  auto_stop_mins   = var.auto_stop_mins
  
  enable_photon         = var.enable_photon
  enable_serverless_compute = var.enable_serverless_compute
  spot_instance_policy  = var.spot_instance_policy
  warehouse_type        = var.warehouse_type
  
  dynamic "channel" {
    for_each = var.channel != null ? [var.channel] : []
    content {
      name = channel.value.name
    }
  }

  dynamic "tags" {
    for_each = var.tags != null ? [var.tags] : []
    content {
      dynamic "custom_tags" {
        for_each = tags.value.custom_tags
        content {
          key   = custom_tags.key
          value = custom_tags.value
        }
      }
    }
  }
}




