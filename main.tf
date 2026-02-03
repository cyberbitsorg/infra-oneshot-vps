# =============================================================================
# SSH Key
# =============================================================================

resource "hcloud_ssh_key" "default" {
  name       = var.ssh_key_name
  public_key = file(pathexpand(var.ssh_public_key_path))
}

# =============================================================================
# Firewall
# =============================================================================

resource "hcloud_firewall" "vps" {
  name = "${var.server_name}-firewall"

  # Inbound rules (SSH, HTTP, HTTPS, ICMP)
  dynamic "rule" {
    for_each = local.firewall_inbound_rules
    content {
      description = rule.value.description
      direction   = "in"
      protocol    = rule.value.protocol
      port        = rule.value.port
      source_ips  = rule.value.source_ips
    }
  }

  # Outbound rules
  dynamic "rule" {
    for_each = local.firewall_outbound_rules
    content {
      description     = rule.value.description
      direction       = "out"
      protocol        = rule.value.protocol
      port            = rule.value.port
      destination_ips = rule.value.destination_ips
    }
  }
}

# =============================================================================
# Admin Password
# =============================================================================

resource "random_password" "admin_password" {
  length  = 20
  special = false
  upper   = true
  lower   = true
  numeric = true
}

# =============================================================================
# Server
# =============================================================================

resource "hcloud_server" "vps" {
  name        = var.server_name
  server_type = var.server_type
  location    = var.server_location
  image       = var.server_image
  backups     = var.server_backups

  ssh_keys     = [hcloud_ssh_key.default.id]
  firewall_ids = [hcloud_firewall.vps.id]

  user_data = templatefile("${path.module}/cloud-init.yaml", {
    admin_username = var.admin_username
    admin_email    = var.admin_email
    ssh_public_key = file(pathexpand(var.ssh_public_key_path))
    timezone       = var.timezone
    domain         = var.domain
    admin_password = random_password.admin_password.result
  })

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  labels = local.labels

  lifecycle {
    ignore_changes = [user_data]
  }
}

# =============================================================================
# Reverse DNS (PTR record) - IPv4 only (IPv6 disabled)
# =============================================================================

resource "hcloud_rdns" "ipv4" {
  server_id  = hcloud_server.vps.id
  ip_address = hcloud_server.vps.ipv4_address
  dns_ptr    = var.domain
}
