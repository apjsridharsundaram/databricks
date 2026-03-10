locals {
  # Map legacy operator symbols to databricks_alert condition op enum
  alert_op = {
    ">"  = "GREATER_THAN"
    "<"  = "LESS_THAN"
    ">=" = "GREATER_THAN_OR_EQUAL"
    "<=" = "LESS_THAN_OR_EQUAL"
    "==" = "EQUAL"
    "!=" = "NOT_EQUAL"
  }
  op = lookup(local.alert_op, var.options_op, var.options_op)
}

resource "databricks_alert" "this" {
  query_id             = var.query_id
  display_name         = var.name
  parent_path          = var.parent
  seconds_to_retrigger = var.rearm
  custom_subject       = var.options_custom_subject
  custom_body          = var.options_custom_body

  condition {
    op = local.op
    operand {
      column {
        name = var.options_column
      }
    }
    threshold {
      value {
        string_value = var.options_value
      }
    }
  }
}
