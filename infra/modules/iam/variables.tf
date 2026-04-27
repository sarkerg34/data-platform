variable "env" {
  description = "Environment name. Used as the service-account name suffix and as a label."
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "env must be \"dev\" or \"prod\"."
  }
}

variable "bucket_names" {
  description = "GCS buckets to grant the writer/reader access on. Bucket-level bindings only — no project-wide grants."
  type        = list(string)

  validation {
    condition     = length(var.bucket_names) > 0
    error_message = "bucket_names must contain at least one bucket."
  }
}
