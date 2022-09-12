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