# Development Environment Configuration
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
    bucket = "financial-predictor-terraform-state-dev"
    prefix = "terraform/state/dev"
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
  environment  = "dev"
  region       = var.region
  zone         = var.zone
  
  # Network Configuration
  private_subnet_cidr  = "10.0.1.0/24"
  public_subnet_cidr   = "10.0.2.0/24"
  services_subnet_cidr = "10.1.0.0/20"
  pods_subnet_cidr     = "10.2.0.0/14"
  vpc_connector_cidr   = "10.8.0.0/28"
  
  # Database Configuration
  db_tier              = "db-f1-micro"
  db_disk_size         = 20
  db_availability_type = "ZONAL"
  db_backup_enabled    = true
  
  # Redis Configuration
  redis_memory_size = 1
  redis_tier        = "BASIC"
  
  # Cloud Run Configuration
  api_cpu    = "1"
  api_memory = "1Gi"
  web_cpu    = "0.5"
  web_memory = "512Mi"
  ml_cpu     = "1"
  ml_memory  = "2Gi"
  
  # Scaling Configuration
  min_instances         = 0
  max_instances         = 3
  container_concurrency = 80
  
  # Cost Control
  budget_amount = 200
  
  # Application Configuration
  app_debug     = true
  app_log_level = "DEBUG"
  
  # Additional labels
  additional_labels = {
    cost_center = "development"
    team        = "engineering"
  }
}