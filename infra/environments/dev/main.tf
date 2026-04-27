variable "project" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "Default GCP region."
  type        = string
}

variable "bucket_name" {
  description = "Data bucket name for this environment."
  type        = string
}

variable "lifecycle_age_days" {
  description = "Delete objects older than this many days. 0 disables."
  type        = number
}

module "gcs_data" {
  source = "../../modules/gcs"

  name               = var.bucket_name
  location           = var.region
  lifecycle_age_days = var.lifecycle_age_days

  labels = {
    project = "github-velocity"
    env     = "dev"
    managed = "terraform"
  }
}

module "iam" {
  source = "../../modules/iam"

  env          = "dev"
  bucket_names = [module.gcs_data.name]
}

module "secrets" {
  source = "../../modules/secrets"

  env          = "dev"
  secret_names = ["github-pat"]
  accessors    = ["serviceAccount:${module.iam.writer_email}"]
}

output "data_bucket" {
  description = "Dev data bucket (name + URL)."
  value = {
    name = module.gcs_data.name
    url  = module.gcs_data.url
  }
}

output "service_accounts" {
  description = "Dev service account emails."
  value = {
    writer = module.iam.writer_email
    reader = module.iam.reader_email
  }
}

output "secrets" {
  description = "Dev Secret Manager secret IDs."
  value       = module.secrets.secret_ids
}
