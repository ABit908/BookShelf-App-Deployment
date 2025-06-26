output "health_check_self_link" {
  description = "Self-link of the health check"
  value       = google_compute_health_check.bookshelf_health_check.self_link
}