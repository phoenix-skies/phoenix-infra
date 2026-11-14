locals {
  name = "phoenix-${var.env_name}"

  # Every API the platform uses, enabled up front.
  services = [
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
    "redis.googleapis.com",
    "pubsub.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com",
    "storage.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
  ]
}

module "services" {
  source     = "../../modules/project-services"
  project_id = var.project_id
  services   = local.services
}

module "network" {
  source = "../../modules/network"

  project_id    = var.project_id
  region        = var.region
  name          = local.name
  subnet_cidr   = var.subnet_cidr
  pods_cidr     = var.pods_cidr
  services_cidr = var.services_cidr

  depends_on = [module.services]
}

# Coming next (Step 5.2 and 5.3): GKE cluster, Cloud SQL, Memorystore,
# Pub/Sub, buckets, Artifact Registry.
