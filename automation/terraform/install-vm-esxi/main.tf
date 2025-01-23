terraform {
  required_providers {
    vsphere = {
      source  = "local/hashicorp/vsphere"
      version = ">= 2.10.0"
    }
  }
  required_version = ">= 0.13"
}

provider "vsphere" {
  user                 = "sina"
  password             = "9913511Remote"
  vsphere_server       = "192.168.1.249"
  allow_unverified_ssl = true
  api_timeout          = 10
}

# Specify the datastore and network for the VM
data "vsphere_datastore" "datastore" {
  name = "SRV-SSD-1TB-R1"
}

data "vsphere_network" "network" {
  name = "vlan-sina"
}

# Define the VM resource configuration
resource "vsphere_virtual_machine" "vm" {
  name             = "new-ubuntu-vm"
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = 2
  memory           = 4096
  guest_id         = "ubuntu64Guest"  # Specify the correct guest OS identifier
  cpu_hot_add_enabled = true
  memory_hot_add_enabled = true

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "disk0"
    size             = 20            # Adjust as needed for your VM
    eagerly_scrub    = false
    thin_provisioned = true
  }

  cdrom {
    datastore_id = data.vsphere_datastore.datastore.id
    path         = "[datastore_name] ISO/ubuntu-22.04.3-live-server-amd64.iso"  # Path to the ISO file
  }

  # Specify boot options to boot from CD-ROM
  boot_delay = 5000
  boot_retry_enabled = true
  boot_retry_delay   = 10000
}

output "vm_ip_address" {
  value = vsphere_virtual_machine.vm.default_ip_address
}
