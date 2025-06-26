resource "google_compute_network" "bookshelf_vpc" {
    name = "bookshelf-vpc"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "bookshelf_subnet" {
  name          = "bookshelf-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.bookshelf_vpc.name
}

resource "google_compute_router" "nat_router" {
  name    = "bookshelf-router"
  region  = var.region
  network = google_compute_network.bookshelf_vpc.name
}

resource "google_compute_router_nat" "nat_config" {
  name = "bookshelf-nat"
  router = google_compute_router.nat_router.name
  region = var.region
  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name = google_compute_subnetwork.bookshelf_subnet.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# Firewall Rules
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.bookshelf_vpc.name
  
  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]


  
}

resource "google_compute_firewall" "allow_health_check" {
  name    = "allow-health-check"
  network = google_compute_network.bookshelf_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["allow-health-check"]
} 
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.bookshelf_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-ssh"]
}
