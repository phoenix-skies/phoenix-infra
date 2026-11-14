variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Region for the subnet, router and NAT"
  type        = string
}

variable "name" {
  description = "Base name for the VPC and its resources, e.g. phoenix-nonprod"
  type        = string
}

variable "subnet_cidr" {
  description = "Primary range for GKE nodes"
  type        = string
}

variable "pods_cidr" {
  description = "Secondary range for GKE pods"
  type        = string
}

variable "services_cidr" {
  description = "Secondary range for GKE services"
  type        = string
}
