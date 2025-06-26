variable "region" {
  type = string
  description = "Region for your GCP resources"
}
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default = "gcp-project-terraform-462411"
}
variable "lastname" {
  description = "My last name"
  type        = string

}