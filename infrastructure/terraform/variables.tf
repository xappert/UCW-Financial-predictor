# Predictive Calculator Web Application - Variables Configuration

# Project Configuration
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "financial-predictor"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone"
  type        = string
  default     = "us-central1-a"
}

# Network Configuration
variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "services_subnet_cidr" {
  description = "CIDR block for services subnet"
  type        = string
  default     = "10.1.0.0/20"
}

variable "pods_subnet_cidr" {
  description = "CIDR block for pods subnet"
  type        = string
  default     = "10.2.0.0/14"
}

variable "vpc_connector_cidr" {
  description = "CIDR block for VPC connector"
  type        = string
  default     = "10.8.0.0/28"
}

# Database Configuration
variable "db_tier" {
  description = "Cloud SQL instance tier"
  type        = string
  default     = "db-f1-micro"
}

variable "db_disk_size" {
  description = "Database disk size in GB"
  type        = number
  default     = 20
}

variable "db_disk_type" {
  description = "Database disk type"
  type        = string
  default     = "PD_SSD"
}

variable "db_backup_enabled" {
  description = "Enable database backups"
  type        = bool
  default     = true
}

variable "db_backup_start_time" {
  description = "Database backup start time"
  type        = string
  default     = "03:00"
}

variable "db_availability_type" {
  description = "Database availability type"
  type        = string
  default     = "ZONAL"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "financial_predictor"
}

variable "db_user" {
  description = "Database username"
  type        = string
  default     = "app_user"
}

# Redis Configuration
variable "redis_memory_size" {
  description = "Redis memory size in GB"
  type        = number
  default     = 1
}

variable "redis_tier" {
  description = "Redis tier"
  type        = string
  default     = "BASIC"
}

variable "redis_version" {
  description = "Redis version"
  type        = string
  default     = "REDIS_7_0"
}

# Cloud Run Configuration
variable "api_image" {
  description = "API container image"
  type        = string
  default     = "gcr.io/PROJECT_ID/financial-predictor-api:latest"
}

variable "web_image" {
  description = "Web container image"
  type        = string
  default     = "gcr.io/PROJECT_ID/financial-predictor-web:latest"
}

variable "ml_service_image" {
  description = "ML service container image"
  type        = string
  default     = "gcr.io/PROJECT_ID/financial-predictor-ml:latest"
}

variable "api_cpu" {
  description = "API service CPU allocation"
  type        = string
  default     = "1"
}

variable "api_memory" {
  description = "API service memory allocation"
  type        = string
  default     = "2Gi"
}

variable "web_cpu" {
  description = "Web service CPU allocation"
  type        = string
  default     = "1"
}

variable "web_memory" {
  description = "Web service memory allocation"
  type        = string
  default     = "1Gi"
}

variable "ml_cpu" {
  description = "ML service CPU allocation"
  type        = string
  default     = "2"
}

variable "ml_memory" {
  description = "ML service memory allocation"
  type        = string
  default     = "4Gi"
}

# Scaling Configuration
variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 0
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 10
}

variable "container_concurrency" {
  description = "Container concurrency"
  type        = number
  default     = 80
}

variable "timeout_seconds" {
  description = "Request timeout in seconds"
  type        = number
  default     = 300
}

# Domain Configuration
variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = ""
}

variable "ssl_certificate_domains" {
  description = "List of domains for SSL certificate"
  type        = list(string)
  default     = []
}

# Storage Configuration
variable "storage_class" {
  description = "Storage class for buckets"
  type        = string
  default     = "STANDARD"
}

variable "storage_lifecycle_age" {
  description = "Age in days for storage lifecycle"
  type        = number
  default     = 365
}

# Monitoring Configuration
variable "monitoring_enabled" {
  description = "Enable monitoring and alerting"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Log retention period in days"
  type        = number
  default     = 30
}

variable "alert_email" {
  description = "Email address for receiving alerts"
  type        = string
}

variable "slack_token" {
  description = "Slack API token for notifications"
  type        = string
  sensitive   = true
}

variable "health_check_path" {
  description = "Endpoint path for health checks"
  type        = string
  default     = "/healthz"
}

# Security Configuration
variable "kms_key_rotation_period" {
  description = "KMS key rotation period"
  type        = string
  default     = "2592000s" # 30 days
}

# Cost Control Configuration
variable "billing_account_id" {
  description = "GCP billing account ID"
  type        = string
}

variable "budget_amount" {
  description = "Monthly budget amount in USD"
  type        = number
  default     = 1000
}

variable "budget_alert_thresholds" {
  description = "Budget alert thresholds"
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 1.0]
}

# External API Configuration
variable "openai_api_key" {
  description = "OpenAI API key (stored in Secret Manager)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "alpha_vantage_api_key" {
  description = "Alpha Vantage API key (stored in Secret Manager)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "stripe_secret_key" {
  description = "Stripe secret key (stored in Secret Manager)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "stripe_webhook_secret" {
  description = "Stripe webhook secret (stored in Secret Manager)"
  type        = string
  default     = ""
  sensitive   = true
}

# Application Configuration
variable "jwt_secret_key" {
  description = "JWT secret key (stored in Secret Manager)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "app_debug" {
  description = "Enable debug mode"
  type        = bool
  default     = false
}

variable "app_log_level" {
  description = "Application log level"
  type        = string
  default     = "INFO"
}

# Email Configuration
variable "sendgrid_api_key" {
  description = "SendGrid API key (stored in Secret Manager)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "from_email" {
  description = "From email address"
  type        = string
  default     = "noreply@financialpredictor.com"
}

# Tags and Labels
variable "additional_labels" {
  description = "Additional labels to apply to resources"
  type        = map(string)
  default     = {}
}

variable "resource_tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}