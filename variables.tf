# =============================================================================
# Hetzner Cloud Configuration
# =============================================================================

variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  type        = string
  sensitive   = true
}

# =============================================================================
# Server Configuration
# =============================================================================

variable "server_name" {
  description = "Name of the server"
  type        = string
  default     = "web-vps"
}

variable "server_type" {
  description = "Hetzner server type (cpx11, cpx21, etc.)"
  type        = string
  default     = "cpx11"
}

variable "server_location" {
  description = "Datacenter location (fsn1, nbg1, hel1, ash, hil)"
  type        = string
  default     = "fsn1" # Falkenstein, Germany
}

variable "server_image" {
  description = "OS image"
  type        = string
  default     = "ubuntu-24.04"
}

variable "server_backups" {
  description = "Enable automatic backups (20% additional cost)"
  type        = bool
  default     = true
}

# =============================================================================
# SSH Configuration
# =============================================================================

variable "ssh_public_key_path" {
  description = "Path to your public SSH key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "ssh_key_name" {
  description = "Name for the SSH key in Hetzner"
  type        = string
  default     = "vps-deploy-key"
}

# =============================================================================
# User Configuration
# =============================================================================

variable "admin_username" {
  description = "Name of the admin user (not root!)"
  type        = string
  default     = "admin"
}

variable "admin_email" {
  description = "Email for alerts and Let's Encrypt"
  type        = string
}

variable "timezone" {
  description = "Server timezone"
  type        = string
  default     = "Europe/Amsterdam"
}

# =============================================================================
# Domain Configuration
# =============================================================================

variable "domain" {
  description = "Primary domain name"
  type        = string
  default     = "example.com"
}

# =============================================================================
# Firewall Configuration
# =============================================================================

variable "allowed_ssh_ips" {
  description = "IP addresses allowed SSH access (CIDR notation). Empty = all IPs"
  type        = list(string)
  default     = []
}

# =============================================================================
# Environment
# =============================================================================

variable "environment" {
  description = "Environment name for labeling (e.g., production, staging, development)"
  type        = string
  default     = "production"
}
