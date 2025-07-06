# Predictive Calculator Web Application - Redis Configuration

# Redis Instance for caching and session management
resource "google_redis_instance" "main" {
  name           = "${local.name_prefix}-redis"
  memory_size_gb = var.redis_memory_size
  region         = var.region
  tier           = var.redis_tier
  redis_version  = var.redis_version
  
  authorized_network = google_compute_network.main.id
  
  redis_configs = {
    maxmemory-policy = "allkeys-lru"
    notify-keyspace-events = "Ex"
    timeout = "300"
    tcp-keepalive = "300"
  }
  
  labels = local.common_labels
  
  depends_on = [
    google_compute_network.main,
    google_project_service.required_apis
  ]
}

# Store Redis connection URL in Secret Manager
resource "google_secret_manager_secret" "redis_url" {
  secret_id = "${local.name_prefix}-redis-url"
  
  labels = local.common_labels
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "redis_url" {
  secret      = google_secret_manager_secret.redis_url.id
  secret_data = local.redis_url
}

# Redis connection details for application configuration
resource "google_secret_manager_secret" "redis_host" {
  secret_id = "${local.name_prefix}-redis-host"
  
  labels = local.common_labels
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "redis_host" {
  secret      = google_secret_manager_secret.redis_host.id
  secret_data = google_redis_instance.main.host
}

resource "google_secret_manager_secret" "redis_port" {
  secret_id = "${local.name_prefix}-redis-port"
  
  labels = local.common_labels
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "redis_port" {
  secret      = google_secret_manager_secret.redis_port.id
  secret_data = tostring(google_redis_instance.main.port)
}