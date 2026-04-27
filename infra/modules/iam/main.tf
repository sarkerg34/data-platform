locals {
  writer_id = "dagster-writer-${var.env}"
  reader_id = "streamlit-reader-${var.env}"
}

resource "google_service_account" "writer" {
  account_id   = local.writer_id
  display_name = "Dagster + dlt writer (${var.env})"
  description  = "Pipeline service account: writes raw + transformed data, manages Iceberg metadata. Managed by Terraform."
}

resource "google_service_account" "reader" {
  account_id   = local.reader_id
  display_name = "Streamlit reader (${var.env})"
  description  = "Dashboard service account: read-only access to transformed data. Managed by Terraform."
}

resource "google_storage_bucket_iam_member" "writer" {
  for_each = toset(var.bucket_names)

  bucket = each.key
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.writer.email}"
}

resource "google_storage_bucket_iam_member" "reader" {
  for_each = toset(var.bucket_names)

  bucket = each.key
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.reader.email}"
}
