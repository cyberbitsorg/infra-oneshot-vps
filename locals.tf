# =============================================================================
# Local Values
# =============================================================================

locals {
  # Network CIDR Blocks
  cidr_ipv4_all = "0.0.0.0/0"
  cidr_ipv6_all = "::/0"
  cidr_all      = [local.cidr_ipv4_all, local.cidr_ipv6_all]

  labels = {
    environment = var.environment
    managed_by  = "opentofu"
    domain      = var.domain
  }

  # Firewall Rules
  firewall_inbound_rules = [
    {
      description = length(var.allowed_ssh_ips) > 0 ? "SSH (restricted)" : "SSH"
      protocol    = "tcp"
      port        = "22"
      source_ips  = local.ssh_source_ips
    },
    {
      description = "HTTP"
      protocol    = "tcp"
      port        = "80"
      source_ips  = local.cidr_all
    },
    {
      description = "HTTPS"
      protocol    = "tcp"
      port        = "443"
      source_ips  = local.cidr_all
    },
    {
      description = "ICMP (ping)"
      protocol    = "icmp"
      port        = null
      source_ips  = local.cidr_all
    }
  ]

  firewall_outbound_rules = [
    {
      description     = "Outbound TCP"
      protocol        = "tcp"
      port            = "any"
      destination_ips = local.cidr_all
    },
    {
      description     = "Outbound UDP"
      protocol        = "udp"
      port            = "any"
      destination_ips = local.cidr_all
    },
    {
      description     = "Outbound ICMP"
      protocol        = "icmp"
      port            = null
      destination_ips = local.cidr_all
    }
  ]

  # SSH source IPs: use allowed_ssh_ips if set, otherwise allow all
  ssh_source_ips = length(var.allowed_ssh_ips) > 0 ? var.allowed_ssh_ips : local.cidr_all
}
