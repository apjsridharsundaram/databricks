# SRA Pattern: Classic compute cluster with security hardening
# - USER_ISOLATION data security mode (default)
# - 10 minute autotermination (default)
# - Local disk encryption enabled (default)
# - AWS Nitro instances recommended (i3.xlarge, m6idn.xlarge)
# - Enhanced security Spark configurations

resource "databricks_cluster" "this" {
  cluster_name            = var.cluster_name
  spark_version           = var.spark_version
  node_type_id            = var.node_type_id
  driver_node_type_id     = var.driver_node_type_id
  num_workers             = var.num_workers
  autotermination_minutes = var.autotermination_minutes
  
  dynamic "autoscale" {
    for_each = var.autoscale != null ? [var.autoscale] : []
    content {
      min_workers = autoscale.value.min_workers
      max_workers = autoscale.value.max_workers
    }
  }

  spark_conf = merge(
    var.spark_conf,
    # Security best practices
    var.enable_enhanced_security ? {
      "spark.databricks.acl.dfAclsEnabled"                    = "true"
      "spark.databricks.repl.allowedLanguages"                = var.allowed_languages
      "spark.databricks.passthrough.enabled"                  = "false"
      "spark.databricks.pyspark.enablePy4JSecurity"          = "true"
    } : {}
  )
  
  custom_tags = merge(
    var.custom_tags,
    {
      "SecurityCompliance" = "true"
      "ManagedBy"         = "Terraform"
    }
  )
  spark_env_vars                  = var.spark_env_vars
  enable_elastic_disk             = var.enable_elastic_disk
  enable_local_disk_encryption    = var.enable_local_disk_encryption
  data_security_mode              = var.data_security_mode
  runtime_engine                  = var.runtime_engine
  instance_pool_id                = var.instance_pool_id
  driver_instance_pool_id         = var.driver_instance_pool_id
  policy_id                       = var.policy_id
  single_user_name                = var.single_user_name
  idempotency_token               = var.idempotency_token
  apply_policy_default_values     = var.apply_policy_default_values
  ssh_public_keys                 = var.ssh_public_keys

  # AWS-specific attributes
  dynamic "aws_attributes" {
    for_each = var.aws_attributes != null ? [var.aws_attributes] : []
    content {
      zone_id                = aws_attributes.value.zone_id
      availability           = aws_attributes.value.availability
      spot_bid_price_percent = aws_attributes.value.spot_bid_price_percent
      instance_profile_arn   = aws_attributes.value.instance_profile_arn
      first_on_demand        = aws_attributes.value.first_on_demand
      ebs_volume_type        = aws_attributes.value.ebs_volume_type
      ebs_volume_count       = aws_attributes.value.ebs_volume_count
      ebs_volume_size        = aws_attributes.value.ebs_volume_size
      ebs_volume_iops        = aws_attributes.value.ebs_volume_iops
      ebs_volume_throughput  = aws_attributes.value.ebs_volume_throughput
    }
  }

  dynamic "init_scripts" {
    for_each = var.init_scripts
    content {
      dynamic "dbfs" {
        for_each = init_scripts.value.dbfs != null ? [init_scripts.value.dbfs] : []
        content {
          destination = dbfs.value.destination
        }
      }
      dynamic "s3" {
        for_each = init_scripts.value.s3 != null ? [init_scripts.value.s3] : []
        content {
          destination = s3.value.destination
          region      = s3.value.region
          endpoint    = s3.value.endpoint
        }
      }
      dynamic "volumes" {
        for_each = init_scripts.value.volumes != null ? [init_scripts.value.volumes] : []
        content {
          destination = volumes.value.destination
        }
      }
      dynamic "workspace" {
        for_each = init_scripts.value.workspace != null ? [init_scripts.value.workspace] : []
        content {
          destination = workspace.value.destination
        }
      }
    }
  }

  dynamic "library" {
    for_each = var.libraries
    content {
      jar = library.value.jar
      egg = library.value.egg
      whl = library.value.whl
      
      dynamic "pypi" {
        for_each = library.value.pypi != null ? [library.value.pypi] : []
        content {
          package = pypi.value.package
          repo    = pypi.value.repo
        }
      }
      dynamic "maven" {
        for_each = library.value.maven != null ? [library.value.maven] : []
        content {
          coordinates = maven.value.coordinates
          repo        = maven.value.repo
          exclusions  = maven.value.exclusions
        }
      }
      dynamic "cran" {
        for_each = library.value.cran != null ? [library.value.cran] : []
        content {
          package = cran.value.package
          repo    = cran.value.repo
        }
      }
    }
  }

  dynamic "cluster_log_conf" {
    for_each = var.cluster_log_conf != null ? [var.cluster_log_conf] : []
    content {
      dynamic "dbfs" {
        for_each = cluster_log_conf.value.dbfs != null ? [cluster_log_conf.value.dbfs] : []
        content {
          destination = dbfs.value.destination
        }
      }
      dynamic "s3" {
        for_each = cluster_log_conf.value.s3 != null ? [cluster_log_conf.value.s3] : []
        content {
          destination       = s3.value.destination
          region            = s3.value.region
          endpoint          = s3.value.endpoint
          enable_encryption = s3.value.enable_encryption
          encryption_type   = s3.value.encryption_type
          kms_key           = s3.value.kms_key
          canned_acl        = s3.value.canned_acl
        }
      }
    }
  }

  dynamic "docker_image" {
    for_each = var.docker_image != null ? [var.docker_image] : []
    content {
      url = docker_image.value.url
      dynamic "basic_auth" {
        for_each = docker_image.value.basic_auth != null ? [docker_image.value.basic_auth] : []
        content {
          username = basic_auth.value.username
          password = basic_auth.value.password
        }
      }
    }
  }

  dynamic "workload_type" {
    for_each = var.workload_type != null ? [var.workload_type] : []
    content {
      dynamic "clients" {
        for_each = workload_type.value.clients != null ? [workload_type.value.clients] : []
        content {
          jobs      = clients.value.jobs
          notebooks = clients.value.notebooks
        }
      }
    }
  }
}
