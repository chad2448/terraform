terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.pm_api_url
  pm_debug        = true
  pm_user         = var.pm_user
  pm_password     = var.pm_password
  pm_tls_insecure = true
}

resource "proxmox_lxc" "debian" {
    target_node     = var.target_node
    hostname        = var.hostname
    ostemplate      = var.ostemplate
    password        = var.container_pass
    start           = true
    tags            = var.tags
    unprivileged    = true
    nameserver      = var.nameserver
    # ssh_public_keys = <<-EOT
    # ssh-rsa some-keys-hash
    # EOT

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
    tag    = 5
  }

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }
}