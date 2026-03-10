resource "databricks_mount" "this" {
  name = var.name
  
  dynamic "s3" {
    for_each = var.s3_config != null ? [var.s3_config] : []
    content {
      bucket_name      = s3.value.bucket_name
      instance_profile = s3.value.instance_profile
    }
  }
  
  cluster_id          = var.cluster_id
  resource_id         = var.resource_id
  encryption_type     = var.encryption_type
  uri                 = var.uri
}




