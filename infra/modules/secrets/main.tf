locals {
  # Key by (secret_name, accessor_index) so for_each keys are known at plan time.
  # The accessor *value* may be (known after apply) — that's fine; only keys must be static.
  secret_access = merge([
    for secret in var.secret_names : {
      for idx, accessor in var.accessors :
      "${secret}|${idx}" => { secret = secret, accessor = accessor }
    }
  ]...)
}

resource "google_secret_manager_secret" "this" {
  for_each = toset(var.secret_names)

  secret_id = "${each.key}-${var.env}"

  replication {
    auto {}
  }

  labels = {
    project = "github-velocity"
    env     = var.env
    managed = "terraform"
  }
}

resource "google_secret_manager_secret_iam_member" "accessor" {
  for_each = local.secret_access

  secret_id = google_secret_manager_secret.this[each.value.secret].id
  role      = "roles/secretmanager.secretAccessor"
  member    = each.value.accessor
}
