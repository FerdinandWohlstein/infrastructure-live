output "server_id" {
  value = module.node.server_id
}

output "public_ipv4" {
  value = module.node.public_ipv4
}

output "public_ipv6" {
  value = module.node.public_ipv6
}

output "elastic_ipv4" {
  value = module.node.elastic_ipv4
}

output "security_group_id" {
  value = module.firewall.security_group_id
}
