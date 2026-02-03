# =============================================================================
# Login Credentials
# =============================================================================

output "login_credentials" {
  description = "SSH login credentials"
  value       = <<-EOT

    Initial Password: ${random_password.admin_password.result}

  EOT
  sensitive = true
}

# =============================================================================
# DNS Configuration
# =============================================================================

output "dns_records" {
  description = "DNS records to configure"
  value       = <<-EOT

    Configure these DNS records at your registrar:

    Type  Name               Value
    ----  ----               -----
    A     ${var.domain}      ${hcloud_server.vps.ipv4_address}
    A     www.${var.domain}  ${hcloud_server.vps.ipv4_address}

  EOT
}

# =============================================================================
# Next Steps
# =============================================================================

output "next_steps" {
  description = "Steps to complete setup"
  value       = <<-EOT

    === NEXT STEPS ===

    1. Configure DNS! Wait until it properly resolves!
       (See DNS records output above)

    2. Wait for cloud-init to complete:
       ssh ${var.admin_username}@${hcloud_server.vps.ipv4_address} 'cloud-init status --wait'

    3. Get your one-time password from tofu state:
       tofu output -raw login_credentials

    4. Login to the server:
       ssh ${var.admin_username}@${hcloud_server.vps.ipv4_address} (enter your SSH key 2FA)

    5. Change the password:
       passwd

    6. Start Traefik and WordPress stack:
       cd /opt/wordpress && sudo ./setup.sh

    -> You'll receive your final instructions after running the above script

  EOT
}
