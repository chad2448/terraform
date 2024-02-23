terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://192.168.1.2:8006/api2/json"
  pm_debug = true
  pm_user = var.pm_user
  pm_password = var.pm_password
  pm_tls_insecure = true
}

resource "proxmox_lxc" "debian" {
    target_node = "promox"
    hostname = "tf-test"
    ostemplate = "local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"
    password = var.container_pass
    unprivileged = true
    ssh_public_keys = <<-EOT
     ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLC/aJpuicQOTSBXaFnUuzZwgC3DP8qByO9SdItZrMz3LNh1jKtvSQE0OHYhJTxWf0xJtziZV1BlvOn+TIH4eXXytxNZNZbhv6TybHNa+M7PAPEW6QXlkPUyzqhjvGdoklbNQ49HIKEflMIPx1UCxM8fYifnXGnTVzcIVgjMowu2puIL1WN/RFmpWWROqJXddZcWQvaNaNznCcyjDzrJqrKGE1WBEcmV0e2PRmW+0QDG4JyFCfurIcZhnRFD4LA02yLub9aXLeWmQ8VJRFPv/TnvmF8D89ElwagfNAkCIM0q36biueJxTNQYXjKem9dVMCmHZn4fXhiQ4ojGK/k3aHeUrUPl27ahnW/T3YcM9japdNPDt5s4UMHzNTaulEo5OTNEthOXEK+6TM2PC250Va1ljoxXXRjUs5lDs/qTRdJpn9Leb84q/SJ6E3ZCWDfNqyirQRdhWgErWf6bLd/kFnES4nvLK64MShn/Hrbq9sxVZSBsduEf3+PBUhakW0Vk8= chad@OfficePC
  EOT

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
  }
  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }
}