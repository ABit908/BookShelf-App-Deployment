variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default = "gcp-project-terraform-462411"
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}
variable "vpc_network_self_link" {
  type = string
}
