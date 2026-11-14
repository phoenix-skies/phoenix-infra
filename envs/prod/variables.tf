variable "project_id" {
  description = "GCP project ID created by bootstrap.sh"
  type        = string
}

variable "region" {
  description = "Primary region (Mumbai)"
  type        = string
  default     = "asia-south1"
}

variable "env_name" {
  description = "Environment name used in resource names"
  type        = string
}

variable "subnet_cidr" {
  description = "GKE node range"
  type        = string
}

variable "pods_cidr" {
  description = "GKE pod range"
  type        = string
}

variable "services_cidr" {
  description = "GKE service range"
  type        = string
}
