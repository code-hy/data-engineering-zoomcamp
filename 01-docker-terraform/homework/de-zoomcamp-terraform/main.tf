terraform {
  required_version = ">= 1.0"
  backend "local" {}  # Stores state locally
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

# Data Lake Bucket (like a folder in the cloud for raw data)
resource "google_storage_bucket" "data_lake_bucket" {
  name          = "${var.project}-data-lake"
  location      = var.region
  storage_class = var.storage_class
  
  # Uniform access control (simpler permissions)
  uniform_bucket_level_access = true
  
  # Versioning keeps old versions if you overwrite files
  versioning {
    enabled = true
  }
  
  # Auto-delete files after 30 days (keeps costs down)
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
  
  # Allows terraform to delete bucket even if it has files
  force_destroy = true
}

# BigQuery Dataset (like a database)
resource "google_bigquery_dataset" "dataset" {
  dataset_id = var.bq_dataset_name
  project    = var.project
  location   = var.region
  
  labels = {
    environment = "dev"
    course      = "de-zoomcamp"
  }
  
  # Set dataset expiration (optional safety)
  default_table_expiration_ms = 3600000  # 1 hour (remove this line for production)
}

# Output the names so you can see them after creation
output "data_lake_bucket" {
  description = "Name of the GCS bucket"
  value       = google_storage_bucket.data_lake_bucket.name
}

output "bigquery_dataset_name" {
  description = "Name of the BigQuery dataset"
  value       = google_bigquery_dataset.dataset.dataset_id
}