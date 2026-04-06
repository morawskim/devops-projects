terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri   = "qemu+ssh://vagrant@127.0.0.1:2222/system?keyfile=.vagrant/machines/default/virtualbox/private_key"
}

locals {
  pool_name = "storage"
  netowrk_name = "bridge"
}

data "libvirt_node_info" "host" {
}
output "host_memory_gb" {
  description = "Total host memory in GB"
  value       = data.libvirt_node_info.host.memory_total_kb / 1024 / 1024
}


# Download cirros cloud image
resource "libvirt_volume" "cirros_image" {
  name   = "cirros.qcow2"
  pool   = local.pool_name
  target = {
    format = {
      type = "qcow2"
    }
  }

  create = {
    content = {
      # cirros cloud image
      url = "https://download.cirros-cloud.net/0.6.3/cirros-0.6.3-x86_64-disk.img"
    }
  }
}

# Create boot disk for VM1 (uses base image as backing store)
resource "libvirt_volume" "vm1_disk" {
  name   = "vm1-disk.qcow2"
  pool   = local.pool_name
  target = {
    format = {
      type = "qcow2"
    }
  }

  # Start with 2GB, will grow as needed
  capacity = 2147483648 # 2GB in bytes

  backing_store = {
    path   = libvirt_volume.cirros_image.path
    format = {
      type = "qcow2"
    }
  }
}


# Cloud-init configuration for VM1
resource "libvirt_cloudinit_disk" "vm1_init" {
  name = "vm1-cloudinit"

  # User-data
  user_data = <<-EOF
    #cloud-config
    # see https://docs.cloud-init.io/en/latest/reference/modules.html
    #
    # lock account and sudo
    # users:
    #  - default:
    #      lock_passwd: true
    #      sudo: ['ALL=(ALL) NOPASSWD:ALL']

    # see https://docs.cloud-init.io/en/latest/reference/datasources.html
    #datasource_list: [ NoCloud, None ]
    # Disable SSH password authentication
    ssh_pwauth: false
    disable_root: true
    # Add SSH public key for key-based auth
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0/Ho... your-key-here

    # Set timezone
    timezone: UTC
    # Set hostname
    hostname: vm1

    growpart:
      mode: auto
      devices: [/]
      ignore_growroot_disabled: false
  EOF

  # Network config: Use DHCP (default behavior)
  network_config = <<-EOF
    version: 2
    ethernets:
      eth0:
        match:
          name: "eth0"
        dhcp4: no
        addresses: [10.0.2.20/24]
        gateway4: 10.0.2.2
        nameservers:
          addresses: [8.8.8.8,8.8.4.4]
  EOF

  meta_data = yamlencode({})
}

# Upload cloud-init ISO for VM1 to a volume
resource "libvirt_volume" "vm1_cloudinit" {
  name = "vm1-cloudinit.iso"
  pool = local.pool_name

  create = {
    content = {
      url = libvirt_cloudinit_disk.vm1_init.path
    }
  }
}

resource "libvirt_domain" "vm1" {
  name      = "vm1"
  memory    = 512
  memory_unit      = "MiB"
  vcpu      = 1
  autostart = true
  running   = true
  type      = "kvm"

  os = {
    type         = "hvm"
    type_arch    = "x86_64"
    type_machine = "q35"
    kernel_args  = "console=ttyS0 root=/dev/vda1"
  }

  devices = {
    disks = [
      # Main system disk
      {
        source = {
          volume = {
            pool   = libvirt_volume.vm1_disk.pool
            volume = libvirt_volume.vm1_disk.name
          }
        }
        target = {
          bus = "virtio"
          dev = "vda"
        }
        driver = {
          type = "qcow2"
        }
      },
      # Cloud-init config disk (will be detected automatically)
      {
        device = "cdrom"
        source = {
          volume = {
            pool   = libvirt_volume.vm1_cloudinit.pool
            volume = libvirt_volume.vm1_cloudinit.name
          }
        }
        target = {
          bus = "sata"
          dev = "sda"
        }
      }
    ]
    interfaces = [
      {
        model = {
          type = "virtio"
        }
        source = {
          network = {
            network = local.netowrk_name
          }
        }
      }
    ]
    consoles = [
      {
        type        = "pty"
        target_port = "0"
        target_type = "serial"
      }
    ]
  }
}
