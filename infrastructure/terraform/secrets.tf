# Predictive Calculator Web Application - Secrets Management Configuration

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

# IAM bindings for secret access
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