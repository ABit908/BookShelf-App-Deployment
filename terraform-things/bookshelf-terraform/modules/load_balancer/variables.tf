variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
}

# variable "mig" {
#     description = "The self-link or id of the MIG"
#     type        = string

# }
# variable "health_check_name" {
#     description = "The name of the health check to use"
#     type        = string
# }
variable "instance_group_name" {}
variable "health_check_self_link" {}