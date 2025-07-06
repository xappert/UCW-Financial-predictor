# Development Environment Variables

variable "project_id" {
  description = "The GCP project ID for development"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "financial-predictor"
}

variable "region" {
  description = "The GCP region for development"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone for development"
  type        = string
  default     = "us-central1-a"
}