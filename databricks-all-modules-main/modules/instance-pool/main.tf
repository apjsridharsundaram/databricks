resource "databricks_instance_pool" "this" {
  instance_pool_name                    = var.instance_pool_name
  min_idle_instances                    = var.min_idle_instances
  max_capacity                          = var.max_capacity
  node_type_id                          = var.node_type_id
  custom_tags                           = var.custom_tags
  idle_instance_autotermination_minutes = var.idle_instance_autotermination_minutes
  enable_elastic_disk                   = var.enable_elastic_disk
  preloaded_spark_versions              = var.preloaded_spark_versions

  dynamic "disk_spec" {
    for_each = var.disk_spec != null ? [var.disk_spec] : []
    content {
      dynamic "disk_type" {
        for_each = disk_spec.value.disk_type != null ? [disk_spec.value.disk_type] : []
        content {
          ebs_volume_type = disk_type.value.ebs_volume_type
          # throughput and iops removed - not supported in current API
        }
      }
      disk_count = disk_spec.value.disk_count
      disk_size  = disk_spec.value.disk_size
    }
  }

  dynamic "aws_attributes" {
    for_each = var.aws_attributes != null ? [var.aws_attributes] : []
    content {
      availability           = aws_attributes.value.availability
      zone_id                = aws_attributes.value.zone_id
      spot_bid_price_percent = aws_attributes.value.spot_bid_price_percent
    }
  }

  dynamic "preloaded_docker_image" {
    for_each = var.preloaded_docker_images
    content {
      url = preloaded_docker_image.value.url
      dynamic "basic_auth" {
        for_each = preloaded_docker_image.value.basic_auth != null ? [preloaded_docker_image.value.basic_auth] : []
        content {
          username = basic_auth.value.username
          password = basic_auth.value.password
        }
      }
    }
  }
}




