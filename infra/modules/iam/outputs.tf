output "writer_email" {
  description = "Pipeline writer service account email."
  value       = google_service_account.writer.email
}

output "reader_email" {
  description = "Dashboard reader service account email."
  value       = google_service_account.reader.email
}
