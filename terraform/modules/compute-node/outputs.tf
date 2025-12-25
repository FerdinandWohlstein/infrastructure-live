output "server_id" {
  value = aws_instance.this.id
}

output "public_ipv4" {
  value = aws_instance.this.public_ip
}

output "public_ipv6" {
  value = aws_instance.this.ipv6_addresses
}

output "elastic_ipv4" {
  value = try(aws_eip.this[0].public_ip, null)
}
