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

data "libvirt_node_info" "host" {
}
output "host_memory_gb" {
  description = "Total host memory in GB"
  value       = data.libvirt_node_info.host.memory_total_kb / 1024 / 1024
}


resource "libvirt_pool" "images" {
  name = "images"
  type = "dir"
  target = {
    path = "/var/lib/libvirt/images"
  }
}


# Download cirros cloud image
resource "libvirt_volume" "cirros_image" {
  name   = "cirros.qcow2"
  pool   = libvirt_pool.images.name
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
  pool   = libvirt_pool.images.name
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
