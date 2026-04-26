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
    env     = "prod"
    managed = "terraform"
  }
}

output "data_bucket" {
  description = "Prod data bucket (name + URL)."
  value = {
    name = module.gcs_data.name
    url  = module.gcs_data.url
  }
}
