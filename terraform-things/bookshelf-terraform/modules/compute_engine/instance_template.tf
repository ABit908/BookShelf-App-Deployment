resource "google_compute_instance_template" "bookshelf_template" {
  name_prefix = "instance-template"
  description = "Bookshelf app instance template"

  machine_type = "e2-medium"
  
  disk {
    source_image = "projects/${var.project_id}/global/images/${var.image}"
    auto_delete  = true
    boot         = true
    type         = "pd-balanced"
    disk_size_gb = 10
  }
 
  network_interface {
    network    = var.vpc_network
    subnetwork = var.subnet
  }
 
  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }
 
  tags = ["http-server","allow-health-check","allow-http", "allow-ssh"]
 
  metadata_startup_script = file("${path.module}/startup-script.sh")
 
  metadata = {
    PROJECT_ID = var.project_id
    CLOUDSQL_USER= var.cloudsql_user
    CLOUDSQL_PASSWORD= var.cloudsql_password
    CLOUDSQL_DATABASE= var.cloudsql_database
    CLOUDSQL_CONNECTION_NAME= var.sql_connection_name
    CLOUD_STORAGE_BUCKET= var.cloud_storage_bucket
    GOOGLE_OAUTH2_CLIENT_ID= var.google_oauth2_client_id
    GOOGLE_OAUTH2_CLIENT_SECRET= var.google_oauth2_client_secret
    DATA_BACKEND= var.data_backend
    enable-oslogin = "FALSE" 
  }

  lifecycle {
    create_before_destroy = true
  }
}
#######   Instance Group   ######

# Reference existing health check
resource "google_compute_region_instance_group_manager" "bookshelf_mig" {
  name               = "bookshelf-mig"
  base_instance_name = "bookshelf-instance"
  region             = var.region

  version {
    instance_template = google_compute_instance_template.bookshelf_template.self_link
  }

  auto_healing_policies {
    health_check      =  var.health_check_name
    initial_delay_sec = 100
  }
  named_port {
    name = "http"
    port = 8080 # or the actual port your app listens on
  }
}

resource "google_compute_region_autoscaler" "bookshelf_autoscaler" {
  name   = "bookshelf-autoscaler"
  region = var.region
  target = google_compute_region_instance_group_manager.bookshelf_mig.self_link

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.8
    }
  }
}
