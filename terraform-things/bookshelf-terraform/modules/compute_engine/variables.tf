variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "gcp-project-terraform-462411"
}

variable "vpc_network" {
  description = "The self-link or id of the VPC network"
  type        = string
}
 
variable "subnet" {
  description = "The self-link or id of the subnet"
  type        = string
}
 
variable "service_account_email" {
  description = "Email of the service account for the VM"
  type        = string
}
 
variable "sql_connection_name" {
  description = "Cloud SQL connection name"
  type        = string
}
 

# App metadata variables
variable "cloudsql_user" {
  description = "Cloud SQL username"
  type        = string
}
 
variable "cloudsql_password" {
  description = "Cloud SQL password"
  type        = string
  sensitive   = true
}
 
variable "cloudsql_database" {
  description = "Cloud SQL database name"
  type        = string
}
 
variable "cloud_storage_bucket" {
  description = "Cloud Storage bucket name"
  type        = string
}
 
variable "google_oauth2_client_id" {
  description = "OAuth2 client ID"
  type        = string
}
 
variable "google_oauth2_client_secret" {
  description = "OAuth2 client secret"
  type        = string
  sensitive   = true
}
 
variable "data_backend" {
  description = "Backend type for data (e.g., cloudsql)"
  type        = string
  default = "cloudsql"
}
variable "image" {
  description = "Boot disk image"
  type        = string
  default     = "bookshelf-image-2"
}

variable "instance_template_name" {
  description = "Name of the existing instance template"
  type        = string
}

variable "health_check_name" {
  description = "Name of the existing health check"
  type        = string
}

variable "region" {
  description = "GCP region for MIG"
  type        = string
  default     = "us-central1"
}
