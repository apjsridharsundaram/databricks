resource "databricks_storage_credential" "this" {
  name    = var.name
  comment = var.comment
  owner   = var.owner
  
  dynamic "aws_iam_role" {
    for_each = var.aws_iam_role != null ? [var.aws_iam_role] : []
    content {
      role_arn = aws_iam_role.value.role_arn
      external_id = aws_iam_role.value.external_id
    }
  }

  read_only       = var.read_only
  skip_validation = var.skip_validation
  force_destroy   = var.force_destroy
  force_update    = var.force_update
  isolation_mode  = var.isolation_mode  # SRA: ISOLATED by default
}


