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
  type = string
  sensitive = true
}

variable "url" {
  type = string
}


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