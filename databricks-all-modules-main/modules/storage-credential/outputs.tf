output "id" {
  description = "The ID of the storage credential"
  value       = databricks_storage_credential.this.id
}

output "name" {
  description = "The name of the storage credential"
  value       = databricks_storage_credential.this.name
}

output "storage_credential_id" {
  description = "The storage credential ID"
  value       = databricks_storage_credential.this.storage_credential_id
}

output "external_id" {
  description = "External ID assigned by Databricks for the AWS IAM role trust policy (when aws_iam_role is set)"
  value       = try(databricks_storage_credential.this.aws_iam_role[0].external_id, null)
}




