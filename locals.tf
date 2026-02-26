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

  # Full domain: subdomain.domain.com or just domain.com
  full_domain = var.subdomain != "" ? "${var.subdomain}.${var.domain}" : var.domain
}
