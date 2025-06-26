resource "google_compute_health_check" "bookshelf_health_check" {
  name               = "bookshelf-health-check"
  project            = var.project_id
  check_interval_sec = 30
  timeout_sec        = 15
  healthy_threshold  = 2
  unhealthy_threshold = 2

  http_health_check {
    port         = 8080
    request_path = "/_ah/health"
    proxy_header = "NONE"
  }

  log_config {
    enable = false
  }
}
