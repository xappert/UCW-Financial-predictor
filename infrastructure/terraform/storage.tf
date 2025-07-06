# Predictive Calculator Web Application - Storage Configuration

# Cloud Storage bucket for user uploads
resource "google_storage_bucket" "uploads" {
  name          = "${var.project_id}-${var.environment}-uploads-${random_id.bucket_suffix.hex}"
  location      = var.region
  storage_class = var.storage_class
  force_destroy = var.environment != "prod"
  
  uniform_bucket_level_access = true
  
  versioning {
    enabled = true
  }
  
  lifecycle_rule {
    condition {
      age = var.storage_lifecycle_age
    }
    action {
      type = "Delete"
    }
  }
  
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
  
  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }
  
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
  
  labels = local.common_labels
}

# Cloud Storage bucket for static assets
resource "google_storage_bucket" "static_assets" {
  name          = "${var.project_id}-${var.environment}-static-${random_id.bucket_suffix.hex}"
  location      = var.region
  storage_class = var.storage_class
  force_destroy = var.environment != "prod"
  
  uniform_bucket_level_access = true
  
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
  
  labels = local.common_labels
}

# Cloud Storage bucket for ML model artifacts
resource "google_storage_bucket" "ml_artifacts" {
  name          = "${var.project_id}-${var.environment}-ml-artifacts-${random_id.bucket_suffix.hex}"
  location      = var.region
  storage_class = var.storage_class
  force_destroy = var.environment != "prod"
  
  uniform_bucket_level_access = true
  
  versioning {
    enabled = true
  }
  
  lifecycle_rule {
    condition {
      age = 180
    }
    action {
      type = "Delete"
    }
  }
  
  labels = merge(local.common_labels, {
    purpose = "ml-artifacts"
  })
}

# Cloud Storage bucket for backups
resource "google_storage_bucket" "backups" {
  name          = "${var.project_id}-${var.environment}-backups-${random_id.bucket_suffix.hex}"
  location      = var.region
  storage_class = "NEARLINE"
  force_destroy = var.environment != "prod"
  
  uniform_bucket_level_access = true
  
  versioning {
    enabled = true
  }
  
  lifecycle_rule {
    condition {
      age = 2555  # 7 years
    }
    action {
      type = "Delete"
    }
  }
  
  lifecycle_rule {
    condition {
      age = 365  # 1 year
    }
    action {
      type = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
  }
  
  labels = merge(local.common_labels, {
    purpose = "backups"
  })
}

# Cloud Storage bucket for logs
resource "google_storage_bucket" "logs" {
  name          = "${var.project_id}-${var.environment}-logs-${random_id.bucket_suffix.hex}"
  location      = var.region
  storage_class = "STANDARD"
  force_destroy = var.environment != "prod"
  
  uniform_bucket_level_access = true
  
  lifecycle_rule {
    condition {
      age = var.log_retention_days
    }
    action {
      type = "Delete"
    }
  }
  
  lifecycle_rule {
    condition {
      age = 7
    }
    action {
      type = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
  
  labels = merge(local.common_labels, {
    purpose = "logs"
  })
}

# IAM bindings for service accounts
resource "google_storage_bucket_iam_binding" "uploads_object_admin" {
  bucket = google_storage_bucket.uploads.name
  role   = "roles/storage.objectAdmin"
  
  members = [
    "serviceAccount:${google_service_account.api.email}",
    "serviceAccount:${google_service_account.web.email}"
  ]
}

resource "google_storage_bucket_iam_binding" "static_assets_object_viewer" {
  bucket = google_storage_bucket.static_assets.name
  role   = "roles/storage.objectViewer"
  
  members = [
    "allUsers"
  ]
}

resource "google_storage_bucket_iam_binding" "ml_artifacts_object_admin" {
  bucket = google_storage_bucket.ml_artifacts.name
  role   = "roles/storage.objectAdmin"
  
  members = [
    "serviceAccount:${google_service_account.ml_service.email}"
  ]
}

resource "google_storage_bucket_iam_binding" "backups_object_admin" {
  bucket = google_storage_bucket.backups.name
  role   = "roles/storage.objectAdmin"
  
  members = [
    "serviceAccount:${google_service_account.backup.email}"
  ]
}