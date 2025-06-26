

# outputs.tf
output "connection_name" {
  description = "Cloud SQL connection name for proxy"
  value       = google_sql_database_instance.bookshelf_sql.connection_name
}

output "db_user" {
  description = "Cloud SQL database username"
  value       = google_sql_user.users.name
}

output "db_password" {
  description = "Cloud SQL database password (sensitive)"
  value       = google_sql_user.users.password
  sensitive   = true
}

output "db_name" {
  description = "Cloud SQL database name"
  value       = google_sql_database.database.name
}
