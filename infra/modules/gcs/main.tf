resource "google_storage_bucket" "this" {
  name     = var.name
  location = var.location

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  versioning {
    enabled = true
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_age_days > 0 ? [1] : []
    content {
      action {
        type = "Delete"
      }
      condition {
        age = var.lifecycle_age_days
      }
    }
  }

  labels = var.labels
}
