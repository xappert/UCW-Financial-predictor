# Predictive Calculator Web Application - Main Infrastructure Configuration
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
    bucket = "financial-predictor-terraform-state"
    prefix = "terraform/state"
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

# Enable required APIs
resource "google_project_service" "required_apis" {
  for_each = toset([
    "compute.googleapis.com",
    "run.googleapis.com",
    "sql.googleapis.com",
    "redis.googleapis.com",
    "storage.googleapis.com",
    "cloudbuild.googleapis.com",
    "secretmanager.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "aiplatform.googleapis.com",
    "cloudkms.googleapis.com",
    "servicenetworking.googleapis.com",
    "vpcaccess.googleapis.com",
    "pubsub.googleapis.com",
    "cloudtasks.googleapis.com",
    "cloudfunctions.googleapis.com",
    "artifactregistry.googleapis.com"
  ])
  
  service                    = each.value
  disable_dependent_services = true
}

# Data sources for project information
data "google_project" "project" {
  project_id = var.project_id
}

data "google_client_config" "current" {}

# Generate random suffixes for global resources
resource "random_id" "bucket_suffix" {
  byte_length = 8
}

# Local values for resource naming
locals {
  name_prefix = "${var.environment}-${var.project_name}"
  
  # Database connection details
  database_url = "postgresql://${google_sql_user.main.name}:${google_sql_user.main.password}@${google_sql_database_instance.main.private_ip_address}:5432/${google_sql_database.main.name}"
  
  # Redis connection details
  redis_url = "redis://${google_redis_instance.main.host}:${google_redis_instance.main.port}"
  
  # Common labels
  common_labels = {
    environment = var.environment
    project     = var.project_name
    managed_by  = "terraform"
  }
}

# VPC Network
resource "google_compute_network" "main" {
  name                    = "${local.name_prefix}-network"
  auto_create_subnetworks = false
  
  depends_on = [google_project_service.required_apis]
}

# Private subnet for application resources
resource "google_compute_subnetwork" "private" {
  name          = "${local.name_prefix}-private-subnet"
  ip_cidr_range = var.private_subnet_cidr
  region        = var.region
  network       = google_compute_network.main.id
  
  # Enable private Google access
  private_ip_google_access = true
  
  # Secondary IP ranges for GKE (if needed in future)
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.services_subnet_cidr
  }
  
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.pods_subnet_cidr
  }
}

# Public subnet for load balancer
resource "google_compute_subnetwork" "public" {
  name          = "${local.name_prefix}-public-subnet"
  ip_cidr_range = var.public_subnet_cidr
  region        = var.region
  network       = google_compute_network.main.id
}

# NAT Gateway for private subnet internet access
resource "google_compute_router" "main" {
  name    = "${local.name_prefix}-router"
  region  = var.region
  network = google_compute_network.main.id
}

resource "google_compute_router_nat" "main" {
  name                               = "${local.name_prefix}-nat"
  router                             = google_compute_router.main.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  
  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# Firewall rules
resource "google_compute_firewall" "allow_internal" {
  name    = "${local.name_prefix}-allow-internal"
  network = google_compute_network.main.name
  
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  
  allow {
    protocol = "icmp"
  }
  
  source_ranges = [var.private_subnet_cidr]
}

resource "google_compute_firewall" "allow_health_check" {
  name    = "${local.name_prefix}-allow-health-check"
  network = google_compute_network.main.name
  
  allow {
    protocol = "tcp"
    ports    = ["8080", "8000"]
  }
  
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["health-check"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "${local.name_prefix}-allow-ssh"
  network = google_compute_network.main.name
  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

# Private Service Connection for Cloud SQL
resource "google_compute_global_address" "private_ip_range" {
  name          = "${local.name_prefix}-private-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.main.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]
  
  depends_on = [google_project_service.required_apis]
}

# VPC Connector for Cloud Run
resource "google_vpc_access_connector" "main" {
  name          = "${local.name_prefix}-vpc-connector"
  region        = var.region
  ip_cidr_range = var.vpc_connector_cidr
  network       = google_compute_network.main.name
  
  depends_on = [google_project_service.required_apis]
}