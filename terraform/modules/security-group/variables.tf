variable "name" {
  type        = string
  description = "Security group name"
}

variable "admin_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to access admin endpoints (SSH/WireGuard)"
  default     = []
}

variable "enable_ssh" {
  type        = bool
  description = "Allow SSH"
  default     = true
}

variable "wireguard_port" {
  type        = number
  description = "WireGuard UDP port"
  default     = 51820
}

variable "public_http" {
  type        = bool
  description = "Allow inbound HTTP 80"
  default     = true
}

variable "public_https" {
  type        = bool
  description = "Allow inbound HTTPS 443"
  default     = true
}
