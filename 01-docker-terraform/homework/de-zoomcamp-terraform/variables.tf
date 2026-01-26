variable "project" {
  description = "de-zoomcamp-2025-485522"
  type        = string
}

variable "region" {
  description = "Region for GCP resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zone for GCP resources"
  type        = string
  default     = "us-central1-a"
}

variable "storage_class" {
  description = "Storage class type for your bucket"
  type        = string
  default     = "STANDARD"
}

variable "bq_dataset_name" {
  description = "BigQuery Dataset Name"
  type        = string
  default     = "ny_taxi_data"
}