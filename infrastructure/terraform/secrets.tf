# Predictive Calculator Web Application - Secrets Management Configuration

# Generate random JWT secret key
resource "random_password" "jwt_secret" {
  length  = 64
  special = true
  upper   = true
  lower   = true
  numeric = true
}

# Application secrets
resource "google_secret_manager_secret" "jwt_secret_key" {
  secret_id = "${local.name_prefix}-jwt-secret-key"
  
  labels = local.common_labels
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "jwt_secret_key" {
  secret      = google_secret_manager_secret.jwt_secret_key.id
  secret_data = var.jwt_secret_key != "" ? var.jwt_secret_key : random_password.jwt_secret.result
}

# External API secrets
resource "google_secret_manager_secret" "openai_api_key" {
  secret_id = "${local.name_prefix}-openai-api-key"
  
  labels = local.common_labels
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "openai_api_key" {
  count = var.openai_api_key != "" ? 1 : 0
  
  secret      = google_secret_manager_secret.openai_api_key.id
  secret_data = var.openai_api_key
}

resource "google_secret_manager_secret" "alpha_vantage_api_key" {
  secret_id = "${local.name_prefix}-alpha-vantage-api-key"
  
  labels = local.common_labels
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "alpha_vantage_api_key" {
  count = var.alpha_vantage_api_key != "" ? 1 : 0
  
  secret      = google_secret_manager_secret.alpha_vantage_api_key.id
  secret_data = var.alpha_vantage_api_key
}

resource "google_secret_manager_secret" "stripe_secret_key" {
  secret_id = "${local.name_prefix}-stripe-secret-key"
  
  labels = local.common_labels
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "stripe_secret_key" {
  count = var.stripe_secret_key != "" ? 1 : 0
  
  secret      = google_secret_manager_secret.stripe_secret_key.id
  secret_data = var.stripe_secret_key
}

resource "google_secret_manager_secret" "stripe_webhook_secret" {
  secret_id = "${local.name_prefix}-stripe-webhook-secret"
  
  labels = local.common_labels
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "stripe_webhook_secret" {
  count = var.stripe_webhook_secret != "" ? 1 : 0
  
  secret      = google_secret_manager_secret.stripe_webhook_secret.id
  secret_data = var.stripe_webhook_secret
}

resource "google_secret_manager_secret" "sendgrid_api_key" {
  secret_id = "${local.name_prefix}-sendgrid-api-key"
  
  labels = local.common_labels
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "sendgrid_api_key" {
  count = var.sendgrid_api_key != "" ? 1 : 0
  
  secret      = google_secret_manager_secret.sendgrid_api_key.id
  secret_data = var.sendgrid_api_key
}

# IAM bindings for secret access
resource "google_secret_manager_secret_iam_binding" "jwt_secret_binding" {
  secret_id = google_secret_manager_secret.jwt_secret_key.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.api.email}",
    "serviceAccount:${google_service_account.cloud_functions.email}"
  ]
}

resource "google_secret_manager_secret_iam_binding" "openai_secret_binding" {
  secret_id = google_secret_manager_secret.openai_api_key.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.api.email}",
    "serviceAccount:${google_service_account.ml_service.email}"
  ]
}

resource "google_secret_manager_secret_iam_binding" "alpha_vantage_secret_binding" {
  secret_id = google_secret_manager_secret.alpha_vantage_api_key.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.api.email}",
    "serviceAccount:${google_service_account.cloud_functions.email}"
  ]
}

resource "google_secret_manager_secret_iam_binding" "stripe_secret_binding" {
  secret_id = google_secret_manager_secret.stripe_secret_key.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.api.email}",
    "serviceAccount:${google_service_account.cloud_functions.email}"
  ]
}

resource "google_secret_manager_secret_iam_binding" "sendgrid_secret_binding" {
  secret_id = google_secret_manager_secret.sendgrid_api_key.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.api.email}",
    "serviceAccount:${google_service_account.cloud_functions.email}"
  ]
}