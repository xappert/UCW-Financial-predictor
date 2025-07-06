# Production Environment Variables

variable "project_id" {
  description = "The GCP project ID for production"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "UCW-financial-predictor"
}

variable "region" {
  description = "The GCP region for production"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone for production"
  type        = string
  default     = "us-central1-a"
}