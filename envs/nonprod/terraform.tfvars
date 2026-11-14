# Replace the project ID with the one bootstrap.sh printed.
project_id = "phoenix-nonprod-REPLACE"
env_name   = "nonprod"

# Non-overlapping ranges so non-prod and prod could be peered later.
subnet_cidr   = "10.10.0.0/20"
pods_cidr     = "10.20.0.0/16"
services_cidr = "10.30.0.0/20"
