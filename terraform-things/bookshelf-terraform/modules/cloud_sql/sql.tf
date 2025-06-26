resource "google_project_service" "servicenetworking" {
  project            = var.project_id  # <- make sure this exists
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "sqladmin" {
  project            = var.project_id
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "service_networking" {
  project = var.project_id
  service = "servicenetworking.googleapis.com"
}

# Allocate IP range for private services access
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16  # Minimum required for Cloud SQL
  network       = var.vpc_network_self_link  # Replace with your VPC network name if different

  depends_on = [google_project_service.service_networking]
}

# Establish service networking connection
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = "projects/${var.project_id}/global/networks/bookshelf-vpc"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
  depends_on              = [google_project_service.service_networking]
}


resource "google_sql_database_instance" "bookshelf_sql" {
  name             = "bookshelf-sql"
  database_version = "MYSQL_8_0"
  region           = var.region
  deletion_protection = false
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = "projects/${var.project_id}/global/networks/bookshelf-vpc"
    }
  }
  
  depends_on = [google_service_networking_connection.private_vpc_connection]
}


resource "google_sql_database" "database" {
  name     = "mydatabase"
  instance = google_sql_database_instance.bookshelf_sql.name
}

resource "google_sql_user" "users" {
  name     = "root"
  instance = google_sql_database_instance.bookshelf_sql.name
  password = "1234567890"
}

