variable "name" {
  description = "Full GCS bucket name. Must be globally unique."
  type        = string
}

variable "location" {
  description = "GCS bucket location. Single-region for cost; per project decision in PRD §GCP."
  type        = string
  default     = "us-central1"
}

variable "lifecycle_age_days" {
  description = "Delete objects older than this many days. Set to 0 to disable lifecycle (production)."
  type        = number
  default     = 0

  validation {
    condition     = var.lifecycle_age_days >= 0
    error_message = "lifecycle_age_days must be 0 (disabled) or a positive integer."
  }
}

variable "labels" {
  description = "Resource labels applied to the bucket."
  type        = map(string)
  default     = {}
}
