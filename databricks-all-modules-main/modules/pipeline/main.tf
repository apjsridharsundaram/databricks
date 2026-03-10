resource "databricks_pipeline" "this" {
  name    = var.name
  storage = var.storage
  target  = var.target
  catalog = var.catalog
  
  dynamic "cluster" {
    for_each = var.clusters
    content {
      label              = cluster.value.label
      node_type_id       = cluster.value.node_type_id
      driver_node_type_id = cluster.value.driver_node_type_id
      num_workers        = cluster.value.num_workers
      custom_tags        = cluster.value.custom_tags
      spark_conf         = cluster.value.spark_conf
      spark_env_vars     = cluster.value.spark_env_vars
      instance_pool_id   = cluster.value.instance_pool_id
      policy_id          = cluster.value.policy_id
      
      dynamic "autoscale" {
        for_each = cluster.value.autoscale != null ? [cluster.value.autoscale] : []
        content {
          min_workers = autoscale.value.min_workers
          max_workers = autoscale.value.max_workers
          mode        = autoscale.value.mode
        }
      }
      
      dynamic "aws_attributes" {
        for_each = cluster.value.aws_attributes != null ? [cluster.value.aws_attributes] : []
        content {
          availability           = aws_attributes.value.availability
          zone_id                = aws_attributes.value.zone_id
          instance_profile_arn   = aws_attributes.value.instance_profile_arn
          spot_bid_price_percent = aws_attributes.value.spot_bid_price_percent
          ebs_volume_type        = aws_attributes.value.ebs_volume_type
          ebs_volume_count       = aws_attributes.value.ebs_volume_count
          ebs_volume_size        = aws_attributes.value.ebs_volume_size
        }
      }
    }
  }

  configuration = var.configuration
  continuous    = var.continuous
  development   = var.development
  edition       = var.edition
  channel       = var.channel
  photon        = var.photon
  allow_duplicate_names = var.allow_duplicate_names

  dynamic "library" {
    for_each = var.libraries
    content {
      dynamic "notebook" {
        for_each = library.value.notebook != null ? [library.value.notebook] : []
        content {
          path = notebook.value.path
        }
      }
      dynamic "file" {
        for_each = library.value.file != null ? [library.value.file] : []
        content {
          path = file.value.path
        }
      }
      jar = library.value.jar
      whl = library.value.whl
      
      dynamic "maven" {
        for_each = library.value.maven != null ? [library.value.maven] : []
        content {
          coordinates = maven.value.coordinates
          repo        = maven.value.repo
          exclusions  = maven.value.exclusions
        }
      }
    }
  }

  dynamic "filters" {
    for_each = var.filters != null ? [var.filters] : []
    content {
      include = filters.value.include
      exclude = filters.value.exclude
    }
  }

  dynamic "notification" {
    for_each = var.notifications
    content {
      email_recipients = notification.value.email_recipients
      alerts           = notification.value.alerts
    }
  }

}




