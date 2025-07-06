# Predictive Calculator - Cost Optimization Configuration

# Budget alerts
resource "google_billing_budget" "monthly_budget" {
  billing_account = var.billing_account_id
  display_name    = "Monthly Budget"

  budget_filter {
    projects = ["projects/${var.project_id}"]
  }

  amount {
    specified_amount {
      currency_code = "USD"
      units         = tostring(var.budget_amount)
    }
  }

  threshold_rules {
    threshold_percent = 0.5
    spend_basis       = "CURRENT_SPEND"
  }
  threshold_rules {
    threshold_percent = 0.75
    spend_basis       = "CURRENT_SPEND"
  }
  threshold_rules {
    threshold_percent = 0.9
    spend_basis       = "CURRENT_SPEND"
  }
  threshold_rules {
    threshold_percent = 1.0
    spend_basis       = "CURRENT_SPEND"
  }

  notifications {
    pubsub_topic = google_pubsub_topic.budget_notifications.id
    schema_version = "1.0"
  }
}

# PubSub topic for budget notifications
resource "google_pubsub_topic" "budget_notifications" {
  name = "billing-budget-notifications"
}

# Resource tagging strategy
module "resource_labels" {
  source = "github.com/terraform-google-modules/label"

  labels = merge(
    var.additional_labels,
    {
      environment = var.environment
      component   = "infrastructure"
      owner       = "finops"
      cost-center = "predictive-calculator"
    }
  )
}