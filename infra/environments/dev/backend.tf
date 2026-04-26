terraform {
  backend "gcs" {
    bucket = "data-engineering-terraform"
    prefix = "github-velocity/dev"
  }
}
