output "network_name" {
  value = module.network.network_name
}

output "subnet_name" {
  value = module.network.subnet_name
}

output "enabled_apis" {
  value = module.services.enabled
}
