terraform {
  required_version = ">= 1.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0"
    }
  }

  # The bucket comes from bootstrap.sh:
  #   terraform init -backend-config="bucket=phoenix-tfstate-<suffix>"
  backend "gcs" {
    prefix = "envs/nonprod"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
