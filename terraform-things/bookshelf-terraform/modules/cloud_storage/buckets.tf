
resource "google_storage_bucket" "tf_bookshelf_bucket" {
  name                        = "buckets-${var.lastname}-34"
  location                    = var.region
  storage_class               = "STANDARD"
  project                     = var.project_id

  uniform_bucket_level_access = true

  soft_delete_policy {
    retention_duration_seconds = 604800
  }

  labels = {
    created_by = "terraform"
  }

  public_access_prevention = "inherited"
}
