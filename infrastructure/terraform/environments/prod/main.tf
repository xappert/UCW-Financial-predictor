# Production Environment Configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }
  
  backend "gcs" {
    bucket = "ucw-financial-predictor-terraform-state-prod"
    prefix = "terraform/state/prod"
  }
}

# Configure the Google Cloud Provider
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Use the main infrastructure module
module "infrastructure" {
  source = "../.."
  
  # Project Configuration
  project_id   = var.project_id
  project_name = var.project_name
  environment  = "prod"
  region       = var.region
  zone         = var.zone
  
  # Network Configuration
  private_subnet_cidr  = "10.0.1.0/24"
  public_subnet_cidr   = "10.0.2.0/24"
  services_subnet_cidr = "10.1.0.0/20"
  pods_subnet_cidr     = "10.2.0.0/14"
  vpc_connector_cidr   = "10.8.0.0/28"
  
  # Database Configuration
  db_tier              = "db-custom-2-7680"
  db_disk_size         = 100
  db_availability_type = "REGIONAL"
  db_backup_enabled    = true
  
  # Redis Configuration
  redis_memory_size = 4
  redis_tier        = "STANDARD_HA"
  
  # Cloud Run Configuration
  api_cpu    = "2"
  api_memory = "4Gi"
  web_cpu    = "1"
  web_memory = "2Gi"
  ml_cpu     = "2"
  ml_memory  = "8Gi"
  
  # Scaling Configuration
  min_instances         = 2
  max_instances         = 20
  container_concurrency = 100
  
  # Domain Configuration
  domain_name             = "financialpredictor.com"
  ssl_certificate_domains = ["financialpredictor.com", "api.financialpredictor.com"]
  
  # Cost Control
  budget_amount = 1000
  
  # Application Configuration
  app_debug     = false
  app_log_level = "INFO"
  
  # Additional labels
  additional_labels = {
    cost_center = "production"
    team        = "engineering"
    criticality = "high"
  }
}