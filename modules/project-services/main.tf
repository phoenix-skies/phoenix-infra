# Enables the Google Cloud APIs a project needs.

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "services" {
  description = "APIs to enable, e.g. container.googleapis.com"
  type        = list(string)
}

resource "google_project_service" "this" {
  for_each = toset(var.services)

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false # never switch an API off by accident
}

output "enabled" {
  description = "APIs enabled by this module"
  value       = [for s in google_project_service.this : s.service]
}
