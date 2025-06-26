# ####### Load Balancer Components #######
# resource "google_compute_backend_service" "bookshelf_backend" {
#   name                  = "bookshelf-backend"
#   project               = var.project_id
#   protocol              = "HTTP"
#   port_name             = "http"
#   timeout_sec           = 30
#   health_checks         = [var.health_check_name]
#   enable_cdn            = false

#   backend {
#     group          = var.mig
#     balancing_mode = "UTILIZATION"
#     capacity_scaler = 1.0
#   }
# }

# resource "google_compute_url_map" "bookshelf_url_map" {
#   name            = "bookshelf-url-map"
#   project         = var.project_id
#   default_service = google_compute_backend_service.bookshelf_backend.self_link
# }

# resource "google_compute_target_http_proxy" "bookshelf_proxy" {
#   name    = "bookshelf-proxy"
#   project = var.project_id
#   url_map = google_compute_url_map.bookshelf_url_map.self_link
# }

# resource "google_compute_global_forwarding_rule" "bookshelf_forwarding_rule" {
#   name       = "bookshelf-forwarding-rule"
#   project    = var.project_id
#   target     = google_compute_target_http_proxy.bookshelf_proxy.self_link
#   port_range = "8080"
# }


resource "google_compute_backend_service" "bookshelf_backend" {
  name          = "bookshelf-backend"
  project       = var.project_id
  protocol      = "HTTP"
  port_name     = "http"
  timeout_sec   = 30
  health_checks = [var.health_check_self_link]

  backend {
    group           = var.instance_group_name
    balancing_mode  = "UTILIZATION"
    # capacity_scaler = 1.0
  }
}

resource "google_compute_url_map" "bookshelf_url_map" {
  name            = "bookshelf-url-map"
  project         = var.project_id
  default_service = google_compute_backend_service.bookshelf_backend.self_link
}

resource "google_compute_target_http_proxy" "bookshelf_proxy" {
  name    = "bookshelf-proxy"
  project = var.project_id
  url_map = google_compute_url_map.bookshelf_url_map.self_link
}

resource "google_compute_global_forwarding_rule" "bookshelf_forwarding_rule" {
  name       = "bookshelf-forwarding-rule"
  project    = var.project_id
  target     = google_compute_target_http_proxy.bookshelf_proxy.self_link
  port_range = "80"
}
