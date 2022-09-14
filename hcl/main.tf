terraform {
  required_providers {
    vcd = {
      source  = "vmware/vcd"
      version = ">= 3.7.0"
    }
  }
}

provider "vcd" {
  user                 = var.user
  password             = var.password
  auth_type            = "integrated"
  url                  = var.url
  sysorg               = "System"
  org                  = "test"
  allow_unverified_ssl = "true"
  logging              = true
}

variable "user" {
  type = string
}

variable "password" {
  type      = string
  sensitive = true
}

variable "url" {
  type = string
}

// ---------------------------------------------

resource "vcd_vm_sizing_policy" "sizing1" {
  name        = "sizing1"
  description = "sizing1 description"
  cpu {
    shares                = "886"
    limit_in_mhz          = "12375"
    count                 = "9"
    speed_in_mhz          = "2500"
    cores_per_socket      = "3"
    reservation_guarantee = "0.55"
  }
}

resource "vcd_vm_sizing_policy" "sizing2" {
  name        = "sizing2"
  description = "sizing2 description"
  cpu {
    shares                = "886"
    limit_in_mhz          = "12375"
    count                 = "9"
    speed_in_mhz          = "2500"
    cores_per_socket      = "3"
    reservation_guarantee = "0.55"
  }
}

resource "vcd_org_vdc" "test-vdc" {
  name = "test-vdc1"
  org  = "test"

  allocation_model  = "Flex"
  network_pool_name = "NSX-T Overlay 1"
  provider_vdc_name = "nsxTPvdc1"

  compute_capacity {
    cpu {
      allocated = "1024"
      limit     = "1024"
    }

    memory {
      allocated = "1024"
      limit     = "1024"
    }
  }

  storage_profile {
    name    = "*"
    enabled = true
    limit   = 10240
    default = true
  }

  enabled                    = true
  enable_thin_provisioning   = true
  enable_fast_provisioning   = true
  delete_force               = true
  delete_recursive           = true
  elasticity                 = false
  include_vm_memory_overhead = false

  default_compute_policy_id = vcd_vm_sizing_policy.sizing1.id
  vm_placement_policy_ids   = []
  vm_sizing_policy_ids      = [vcd_vm_sizing_policy.sizing1.id, vcd_vm_sizing_policy.sizing2.id]
}

resource "vcd_vapp" "test-vapp" {
  name = "test1"
  org  = "test"
  vdc  = vcd_org_vdc.test-vdc.name
}

data "vcd_catalog" "test-catalog" {
  org  = "test"
  name = "cat-test-nsxt-backed"
}

data "vcd_catalog_item" "my-first-item" {
  org     = "test"
  catalog = data.vcd_catalog.test-catalog.name
  name    = "test_media_nsxt"
}

resource "vcd_vapp_vm" "test-vm" {
  name          = "test1"
  org           = "test"
  vdc           = vcd_org_vdc.test-vdc.name
  vapp_name     = vcd_vapp.test-vapp.name
  catalog_name  = data.vcd_catalog.test-catalog.name
  template_name = data.vcd_catalog_item.my-first-item.name
  cpus          = 2
  memory        = 2048
}