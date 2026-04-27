output "secret_ids" {
  description = "Map of base secret name (no env suffix) -> fully qualified secret resource ID."
  value       = { for k, s in google_secret_manager_secret.this : k => s.id }
}
