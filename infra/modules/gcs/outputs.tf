output "name" {
  description = "GCS bucket name."
  value       = google_storage_bucket.this.name
}

output "url" {
  description = "GCS bucket gs:// URL."
  value       = google_storage_bucket.this.url
}

output "self_link" {
  description = "GCS bucket self link."
  value       = google_storage_bucket.this.self_link
}
