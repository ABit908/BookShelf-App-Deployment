provider "google" {
  credentials = file(var.gcp_svc_key)
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}