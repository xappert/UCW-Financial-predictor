# Predictive Calculator Web Application - IAM Configuration

# API Service Account
resource "google_service_account" "api" {
  account_id   = "${local.name_prefix}-api"
  display_name = "API Service Account"
  description  = "Service account for API Cloud Run service"
}

# Web Service Account
resource "google_service_account" "web" {
  account_id   = "${local.name_prefix}-web"
  display_name = "Web Service Account"
  description  = "Service account for Web Cloud Run service"
}

# ML Service Account
resource "google_service_account" "ml_service" {
  account_id   = "${local.name_prefix}-ml-service"
  display_name = "ML Service Account"
  description  = "Service account for ML Cloud Run service"
}

# Cloud Functions Service Account
resource "google_service_account" "cloud_functions" {
  account_id   = "${local.name_prefix}-functions"
  display_name = "Cloud Functions Service Account"
  description  = "Service account for Cloud Functions"
}

# Backup Service Account
resource "google_service_account" "backup" {
  account_id   = "${local.name_prefix}-backup"
  display_name = "Backup Service Account"
  description  = "Service account for backup operations"
}

# Cloud Build Service Account
resource "google_service_account" "cloud_build" {
  account_id   = "${local.name_prefix}-build"
  display_name = "Cloud Build Service Account"
  description  = "Service account for Cloud Build CI/CD"
}

# API Service Account IAM Bindings
resource "google_project_iam_binding" "api_sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  members = [
    "serviceAccount:${google_service_account.api.email}"
  ]
}

resource "google_project_iam_binding" "api_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.api.email}"
  ]
}

resource "google_project_iam_binding" "api_pubsub_publisher" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  members = [
    "serviceAccount:${google_service_account.api.email}"
  ]
}

resource "google_project_iam_binding" "api_tasks_enqueuer" {
  project = var.project_id
  role    = "roles/cloudtasks.enqueuer"
  members = [
    "serviceAccount:${google_service_account.api.email}"
  ]
}

resource "google_project_iam_binding" "api_monitoring_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  members = [
    "serviceAccount:${google_service_account.api.email}"
  ]
}

resource "google_project_iam_binding" "api_logging_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  members = [
    "serviceAccount:${google_service_account.api.email}"
  ]
}

# ML Service Account IAM Bindings
resource "google_project_iam_binding" "ml_vertex_ai_user" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  members = [
    "serviceAccount:${google_service_account.ml_service.email}"
  ]
}

resource "google_project_iam_binding" "ml_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.ml_service.email}"
  ]
}

resource "google_project_iam_binding" "ml_monitoring_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  members = [
    "serviceAccount:${google_service_account.ml_service.email}"
  ]
}

# Cloud Functions Service Account IAM Bindings
resource "google_project_iam_binding" "functions_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.cloud_functions.email}"
  ]
}

resource "google_project_iam_binding" "functions_sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  members = [
    "serviceAccount:${google_service_account.cloud_functions.email}"
  ]
}

resource "google_project_iam_binding" "functions_pubsub_subscriber" {
  project = var.project_id
  role    = "roles/pubsub.subscriber"
  members = [
    "serviceAccount:${google_service_account.cloud_functions.email}"
  ]
}

# Cloud Build Service Account IAM Bindings
resource "google_project_iam_binding" "build_cloud_run_developer" {
  project = var.project_id
  role    = "roles/run.developer"
  members = [
    "serviceAccount:${google_service_account.cloud_build.email}"
  ]
}

resource "google_project_iam_binding" "build_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.cloud_build.email}"
  ]
}

resource "google_project_iam_binding" "build_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.cloud_build.email}"
  ]
}

resource "google_project_iam_binding" "build_artifact_registry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  members = [
    "serviceAccount:${google_service_account.cloud_build.email}"
  ]
}

# Backup Service Account IAM Bindings
resource "google_project_iam_binding" "backup_sql_admin" {
  project = var.project_id
  role    = "roles/cloudsql.admin"
  members = [
    "serviceAccount:${google_service_account.backup.email}"
  ]
}

# Create service account keys for GitHub Actions
resource "google_service_account_key" "cloud_build" {
  service_account_id = google_service_account.cloud_build.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

# Store service account key in Secret Manager for GitHub Actions
resource "google_secret_manager_secret" "github_actions_sa_key" {
  secret_id = "${local.name_prefix}-github-actions-sa-key"
  
  labels = local.common_labels
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "github_actions_sa_key" {
  secret      = google_secret_manager_secret.github_actions_sa_key.id
  secret_data = base64decode(google_service_account_key.cloud_build.private_key)
}

# Custom IAM role for API service with minimal permissions
resource "google_project_iam_custom_role" "api_service_role" {
  role_id     = "${replace(local.name_prefix, "-", "_")}_api_service"
  title       = "API Service Custom Role"
  description = "Custom role for API service with minimal required permissions"
  
  permissions = [
    "cloudsql.instances.connect",
    "secretmanager.versions.access",
    "pubsub.messages.publish",
    "cloudtasks.tasks.create",
    "monitoring.metricDescriptors.create",
    "monitoring.metricDescriptors.get",
    "monitoring.metricDescriptors.list",
    "monitoring.monitoredResourceDescriptors.get",
    "monitoring.monitoredResourceDescriptors.list",
    "monitoring.timeSeries.create",
    "logging.logEntries.create",
    "run.services.get",
    "run.services.invoke"
  ]
}

# Custom IAM role for ML service
resource "google_project_iam_custom_role" "ml_service_role" {
  role_id     = "${replace(local.name_prefix, "-", "_")}_ml_service"
  title       = "ML Service Custom Role"
  description = "Custom role for ML service with AI platform permissions"
  
  permissions = [
    "aiplatform.endpoints.predict",
    "aiplatform.models.predict",
    "storage.objects.get",
    "storage.objects.create",
    "storage.objects.delete",
    "secretmanager.versions.access",
    "monitoring.metricDescriptors.create",
    "monitoring.timeSeries.create",
    "logging.logEntries.create"
  ]
}

# Bind custom roles to service accounts
resource "google_project_iam_binding" "api_custom_role" {
  project = var.project_id
  role    = google_project_iam_custom_role.api_service_role.id
  members = [
    "serviceAccount:${google_service_account.api.email}"
  ]
}

resource "google_project_iam_binding" "ml_custom_role" {
  project = var.project_id
  role    = google_project_iam_custom_role.ml_service_role.id
  members = [
    "serviceAccount:${google_service_account.ml_service.email}"
  ]
}