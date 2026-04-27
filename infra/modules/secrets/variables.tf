variable "env" {
  description = "Environment name. Used as the secret name suffix and as a label."
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "env must be \"dev\" or \"prod\"."
  }
}

variable "secret_names" {
  description = "Base secret names. The env suffix is appended automatically (e.g. \"github-pat\" -> \"github-pat-dev\")."
  type        = list(string)

  validation {
    condition     = length(var.secret_names) > 0
    error_message = "secret_names must contain at least one entry."
  }
}

variable "accessors" {
  description = "IAM members granted roles/secretmanager.secretAccessor on each secret. Format: \"serviceAccount:<email>\" or \"user:<email>\"."
  type        = list(string)
  default     = []
}
