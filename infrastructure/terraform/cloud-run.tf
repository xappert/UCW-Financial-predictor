# Predictive Calculator Web Application - Cloud Run Configuration

# API Service
resource "google_cloud_run_service" "api" {
  name     = "${local.name_prefix}-api"
  location = var.region
  
  template {
    spec {
      service_account_name = google_service_account.api.email
      
      containers {
        image = replace(var.api_image, "PROJECT_ID", var.project_id)
        
        ports {
          container_port = 8000
        }
        
        env {
          name = "DATABASE_URL"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.database_url.secret_id
              key  = "latest"
            }
          }
        }
        
        env {
          name = "REDIS_URL"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.redis_url.secret_id
              key  = "latest"
            }
          }
        }
        
        env {
          name = "OPENAI_API_KEY"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.openai_api_key.secret_id
              key  = "latest"
            }
          }
        }
        
        env {
          name = "ALPHA_VANTAGE_API_KEY"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.alpha_vantage_api_key.secret_id
              key  = "latest"
            }
          }
        }
        
        env {
          name = "STRIPE_SECRET_KEY"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.stripe_secret_key.secret_id
              key  = "latest"
            }
          }
        }
        
        env {
          name = "JWT_SECRET_KEY"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.jwt_secret_key.secret_id
              key  = "latest"
            }
          }
        }
        
        env {
          name  = "ENVIRONMENT"
          value = var.environment
        }
        
        env {
          name  = "GCP_PROJECT_ID"
          value = var.project_id
        }
        
        env {
          name  = "GCP_REGION"
          value = var.region
        }
        
        env {
          name  = "LOG_LEVEL"
          value = var.app_log_level
        }
        
        env {
          name  = "DEBUG"
          value = tostring(var.app_debug)
        }
        
        resources {
          limits = {
            cpu    = var.api_cpu
            memory = var.api_memory
          }
        }
        
        liveness_probe {
          http_get {
            path = "/health"
            port = 8000
          }
          initial_delay_seconds = 30
          period_seconds        = 60
          timeout_seconds       = 10
          failure_threshold     = 3
        }
        
        startup_probe {
          http_get {
            path = "/health"
            port = 8000
          }
          initial_delay_seconds = 10
          period_seconds        = 10
          timeout_seconds       = 5
          failure_threshold     = 30
        }
      }
      
      # VPC Connector for private network access
      vpc_access {
        connector = google_vpc_access_connector.main.id
        egress    = "private-ranges-only"
      }
      
      container_concurrency = var.container_concurrency
      timeout_seconds       = var.timeout_seconds
    }
    
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale"                = tostring(var.min_instances)
        "autoscaling.knative.dev/maxScale"                = tostring(var.max_instances)
        "run.googleapis.com/execution-environment"        = "gen2"
        "run.googleapis.com/cpu-throttling"               = "true"
        "run.googleapis.com/vpc-access-connector"         = google_vpc_access_connector.main.id
        "run.googleapis.com/vpc-access-egress"            = "private-ranges-only"
      }
      
      labels = local.common_labels
    }
  }
  
  traffic {
    percent         = 100
    latest_revision = true
  }
  
  depends_on = [
    google_project_service.required_apis,
    google_service_account.api,
    google_vpc_access_connector.main
  ]
}

# Web Service
resource "google_cloud_run_service" "web" {
  name     = "${local.name_prefix}-web"
  location = var.region
  
  template {
    spec {
      service_account_name = google_service_account.web.email
      
      containers {
        image = replace(var.web_image, "PROJECT_ID", var.project_id)
        
        ports {
          container_port = 3000
        }
        
        env {
          name  = "NEXT_PUBLIC_API_URL"
          value = google_cloud_run_service.api.status[0].url
        }
        
        env {
          name  = "NEXT_PUBLIC_ENVIRONMENT"
          value = var.environment
        }
        
        env {
          name  = "NODE_ENV"
          value = var.environment == "prod" ? "production" : "development"
        }
        
        resources {
          limits = {
            cpu    = var.web_cpu
            memory = var.web_memory
          }
        }
        
        liveness_probe {
          http_get {
            path = "/api/health"
            port = 3000
          }
          initial_delay_seconds = 30
          period_seconds        = 60
          timeout_seconds       = 10
          failure_threshold     = 3
        }
        
        startup_probe {
          http_get {
            path = "/api/health"
            port = 3000
          }
          initial_delay_seconds = 10
          period_seconds        = 10
          timeout_seconds       = 5
          failure_threshold     = 30
        }
      }
      
      container_concurrency = var.container_concurrency
      timeout_seconds       = var.timeout_seconds
    }
    
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale"         = tostring(var.min_instances)
        "autoscaling.knative.dev/maxScale"         = tostring(var.max_instances)
        "run.googleapis.com/execution-environment" = "gen2"
        "run.googleapis.com/cpu-throttling"        = "true"
      }
      
      labels = local.common_labels
    }
  }
  
  traffic {
    percent         = 100
    latest_revision = true
  }
  
  depends_on = [
    google_project_service.required_apis,
    google_service_account.web,
    google_cloud_run_service.api
  ]
}

# ML Service
resource "google_cloud_run_service" "ml_service" {
  name     = "${local.name_prefix}-ml-service"
  location = var.region
  
  template {
    spec {
      service_account_name = google_service_account.ml_service.email
      
      containers {
        image = replace(var.ml_service_image, "PROJECT_ID", var.project_id)
        
        ports {
          container_port = 8080
        }
        
        env {
          name  = "ENVIRONMENT"
          value = var.environment
        }
        
        env {
          name  = "GCP_PROJECT_ID"
          value = var.project_id
        }
        
        env {
          name  = "GCP_REGION"
          value = var.region
        }
        
        env {
          name  = "MODEL_BUCKET"
          value = google_storage_bucket.ml_artifacts.name
        }
        
        resources {
          limits = {
            cpu    = var.ml_cpu
            memory = var.ml_memory
          }
        }
        
        liveness_probe {
          http_get {
            path = "/health"
            port = 8080
          }
          initial_delay_seconds = 60
          period_seconds        = 60
          timeout_seconds       = 10
          failure_threshold     = 3
        }
        
        startup_probe {
          http_get {
            path = "/health"
            port = 8080
          }
          initial_delay_seconds = 30
          period_seconds        = 10
          timeout_seconds       = 5
          failure_threshold     = 60
        }
      }
      
      # VPC Connector for private network access
      vpc_access {
        connector = google_vpc_access_connector.main.id
        egress    = "private-ranges-only"
      }
      
      container_concurrency = 10  # Lower concurrency for ML workloads
      timeout_seconds       = 900  # 15 minutes for ML processing
    }
    
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale"         = "0"
        "autoscaling.knative.dev/maxScale"         = "5"
        "run.googleapis.com/execution-environment" = "gen2"
        "run.googleapis.com/cpu-throttling"        = "false"
        "run.googleapis.com/vpc-access-connector"  = google_vpc_access_connector.main.id
        "run.googleapis.com/vpc-access-egress"     = "private-ranges-only"
      }
      
      labels = merge(local.common_labels, {
        component = "ml-service"
      })
    }
  }
  
  traffic {
    percent         = 100
    latest_revision = true
  }
  
  depends_on = [
    google_project_service.required_apis,
    google_service_account.ml_service,
    google_vpc_access_connector.main
  ]
}

# Allow public access to web service
resource "google_cloud_run_service_iam_binding" "web_public" {
  location = google_cloud_run_service.web.location
  service  = google_cloud_run_service.web.name
  role     = "roles/run.invoker"
  members  = ["allUsers"]
}

# Allow public access to API service
resource "google_cloud_run_service_iam_binding" "api_public" {
  location = google_cloud_run_service.api.location
  service  = google_cloud_run_service.api.name
  role     = "roles/run.invoker"
  members  = ["allUsers"]
}

# Allow API service to invoke ML service
resource "google_cloud_run_service_iam_binding" "ml_service_api_access" {
  location = google_cloud_run_service.ml_service.location
  service  = google_cloud_run_service.ml_service.name
  role     = "roles/run.invoker"
  members  = [
    "serviceAccount:${google_service_account.api.email}"
  ]
}