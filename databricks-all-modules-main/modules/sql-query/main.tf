resource "databricks_query" "this" {
  display_name  = var.name
  warehouse_id  = var.data_source_id
  description   = var.description
  query_text    = var.query
  parent_path   = var.parent
  run_as_mode   = upper(var.run_as_role)
  tags          = [for k, v in var.tags : "${k}:${v}"]

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      title = parameter.value.title

      dynamic "text_value" {
        for_each = parameter.value.text != null ? [parameter.value.text] : []
        content {
          value = text_value.value.value
        }
      }

      dynamic "numeric_value" {
        for_each = parameter.value.number != null ? [parameter.value.number] : []
        content {
          value = numeric_value.value.value
        }
      }

      dynamic "enum_value" {
        for_each = parameter.value.enum != null ? [parameter.value.enum] : []
        content {
          enum_options = enum_value.value.options
          values       = [enum_value.value.value]
        }
      }

      dynamic "query_backed_value" {
        for_each = parameter.value.query_param != null ? [parameter.value.query_param] : []
        content {
          query_id = query_backed_value.value.query_id
          values   = [query_backed_value.value.value]
        }
      }

      dynamic "date_value" {
        for_each = concat(
          parameter.value.date != null ? [parameter.value.date] : [],
          parameter.value.datetime != null ? [parameter.value.datetime] : []
        )
        content {
          date_value = date_value.value.value
        }
      }

      dynamic "date_range_value" {
        for_each = try(parameter.value.datetimerange, null) != null ? [parameter.value.datetimerange] : []
        content {
          dynamic_date_range_value = "${try(date_range_value.value.start, "")} ${try(date_range_value.value.end, "")}"
        }
      }
    }
  }
}
