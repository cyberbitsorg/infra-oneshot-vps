# Infrastructure as Code - Hetzner VPS

Automated, secure WordPress VPS deployment with OpenTofu and cloud-init.

## What Gets Installed?

After `tofu apply`, cloud-init configures **everything** on first boot.


### Infrastructure

- Docker with security configuration
- Traefik reverse proxy with Let's Encrypt
- WordPress stack (MariaDB + PHP-FPM + Nginx + Redis)
- Heavy focus on security. See below for details

## Requirements

- [OpenTofu](https://opentofu.org/docs/intro/install/) >= 1.6
- Hetzner Cloud account with API token
- SSH key pair (ed25519 recommended)
- Domain name

## Quick Start

### 1. Generate SSH Key (if needed)

```bash
ssh-keygen -t ed25519 -C "your-domain" -f ~/.ssh/id_ed25519
```

Always use a password on your key!

### 2. Create Hetzner API Token

1. Go to [Hetzner Cloud Console](https://console.hetzner.cloud/)
2. Select or create your project
3. Go to **Security** → **API Tokens**
4. Generate token with Read & Write permissions

### 3. Configure

```bash
cp terraform.tfvars.example terraform.tfvars
vim terraform.tfvars
```

Minimum required:

```hcl
hcloud_token = "your-api-token"
admin_email  = "you@example.com"
domain       = "your-domain.com"
admin_username = "yourusername"
```

### 4. Deploy

```bash
tofu init
tofu apply
```

### 5. Configure DNS (before setup!)

Set these records at your registrar:

| Type | Name | Value |
|------|------|-------|
| A | your-domain.com | `<IPv4 from tofu output>` |
| A | www.your-domain.com | `<IPv4 from tofu output>` |

Wait for DNS propagation.

### 6. Start WordPress

Follow the rest of the instructions.

## Useful Commands

```bash
# Validate
tofu validate

# Plan
tofu plan

# Deploy
tofu apply

# Show outputs
tofu output

# Destroy all resources
tofu destroy
```

## After SSH Login

```bash
# Check security status
security-check

# Docker status
dps
```

## What's Secured?

### Network

- Hetzner + UFW firewall (ports 22, 80, 443 only)
- Traefik rate limiting (100 req/s, 50 burst)
- IPv6 disabled (reduces attack surface)
- Kernel hardening: SYN cookies, IP spoofing/redirects blocked, ARP hardening

### SSH

- Key-only authentication (ed25519/rsa)
- Root login disabled, password auth disabled
- Fail2Ban (7-day bans, email alerts)
- Modern ciphers, X11/TCP forwarding disabled
- 5-minute idle timeout, max 3 sessions

### Web

- HTTPS with auto-redirect
- HSTS (1 year, preload)
- Security headers: XSS, clickjacking, nosniff, permissions policy
- Nginx server_tokens off, Traefik dashboard disabled
- WordPress: file editor disabled, XML-RPC blocked, PHP execution blocked in uploads

### Database

- MariaDB: symbolic links disabled, local file loading disabled, binary logging disabled, max 100 connections

### Stack Isolation

- WordPress on internal network segment (no direct external access)
- Docker socket read-only, Traefik config read-only
- No-new-privileges for all containers

### System

- Automatic security updates with email alerts
- Kernel dmesg/kptr restricted, swap hardening
- AppArmor + Auditd active
- MOTD security banner

## License

Free to use. No warranties.
