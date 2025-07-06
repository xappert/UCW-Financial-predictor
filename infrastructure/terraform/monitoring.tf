# Predictive Calculator - Monitoring Infrastructure
resource "google_monitoring_dashboard" "app_dashboard" {
  dashboard_json = <<EOF
{
  "displayName": "Predictive Calculator Dashboard",
  "gridLayout": {
    "widgets": [
      {
        "title": "API Request Rate",
        "xyChart": {
          "dataSets": [{
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "metric.type=\"run.googleapis.com/request_count\" resource.type=\"cloud_run_revision\"",
                "aggregation": {
                  "perSeriesAligner": "ALIGN_RATE",
                  "crossSeriesReducer": "REDUCE_SUM",
                  "groupByFields": ["resource.label.service_name"]
                }
              }
            },
            "plotType": "LINE"
          }]
        }
      },
      {
        "title": "Error Rate",
        "xyChart": {
          "dataSets": [{
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "metric.type=\"run.googleapis.com/request_count\" resource.type=\"cloud_run_revision\" metric.label.response_code_class!=\"200\"",
                "aggregation": {
                  "perSeriesAligner": "ALIGN_RATE",
                  "crossSeriesReducer": "REDUCE_SUM"
                }
              }
            },
            "plotType": "STACKED_BAR"
          }]
        }
      },
      {
        "title": "System Resources",
        "scorecard": {
          "timeSeriesQuery": {
            "timeSeriesFilter": {
              "filter": "metric.type=\"run.googleapis.com/container/cpu/utilization\" resource.type=\"cloud_run_revision\"",
              "aggregation": {
                "perSeriesAligner": "ALIGN_MEAN",
                "crossSeriesReducer": "REDUCE_MEAN"
              }
            }
          }
        }
      }
    ]
  }
}
EOF
}

# Error log metric
resource "google_logging_metric" "app_errors" {
  name   = "${local.name_prefix}-application-errors"
  filter = "resource.type=\"cloud_run_revision\" severity>=ERROR"
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    labels {
      key = "service"
      value_type = "STRING"
    }
  }
  label_extractors = {
    "service" = "EXTRACT(resource.labels.service_name)"
  }
}

# Alert policies
resource "google_monitoring_alert_policy" "high_error_rate" {
  display_name = "High Error Rate (5%)"
  combiner     = "OR"
  
  conditions {
    display_name = "Error rate threshold"
    condition_threshold {
      filter     = "metric.type=\"run.googleapis.com/request_count\" resource.type=\"cloud_run_revision\" AND metric.labels.response_code_class!=\"200\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      threshold_value = 0.05
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["resource.label.service_name"]
      }
    }
  }
  
  notification_channels = [
    google_monitoring_notification_channel.email.id,
    google_monitoring_notification_channel.slack.id
  ]
}

# Notification channels
resource "google_monitoring_notification_channel" "email" {
  display_name = "Email Alerts"
  type         = "email"
  labels = {
    email_address = var.alert_email
  }
}

resource "google_monitoring_notification_channel" "slack" {
  display_name = "Slack Alerts"
  type         = "slack"
  labels = {
    channel_name = "#alerts"
  }
  sensitive_labels {
    auth_token = var.slack_token
  }
}

# Uptime check
resource "google_monitoring_uptime_check_config" "api_health_check" {
  display_name = "API Health Check"
  timeout      = "10s"
  period       = "60s"

  http_check {
    path         = "/healthz"
    port         = 443
    use_ssl      = true
    validate_ssl = true
  }

  monitored_resource {
    type = "cloud_run_revision"
    labels = {
      service_name = google_cloud_run_service.api.name
      location     = var.region
    }
  }
}