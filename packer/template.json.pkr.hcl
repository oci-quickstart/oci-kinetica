
variable "availibilty_domain" {
  type    = string
  default = "${env("PACKER_availibilty_domain")}"
}

variable "base_image_ocid" {
  type    = string
  default = "${env("PACKER_base_image")}"
}

variable "compartment_ocid" {
  type    = string
  default = "${env("PACKER_compartment_ocid")}"
}

variable "shape" {
  type    = string
  default = "${env("PACKER_shape")}"
}

variable "ssh_username" {
  type    = string
  default = "opc"
}

variable "subnet_ocid" {
  type    = string
  default = "${env("PACKER_subnet_ocid")}"
}

variable "type" {
  type    = string
  default = "oracle-oci"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

packer {
  required_plugins {
    oracle-oci = {
      version = ">= 1.0.3"
      source = "github.com/hashicorp/oracle"
    }
  }
}

source "oracle-oci" "autogenerated_1" {
  availability_domain = "${var.availibilty_domain}"
  base_image_ocid     = "${var.base_image_ocid}"
  compartment_ocid    = "${var.compartment_ocid}"
  image_launch_mode   = "PARAVIRTUALIZED"
  image_name          = "kinetica-${var.shape}-${local.timestamp}"
  nic_attachment_type = "PARAVIRTUALIZED"
  shape               = "${var.shape}"
  ssh_username        = "${var.ssh_username}"
  subnet_ocid         = "${var.subnet_ocid}"
}

build {
  sources = ["source.oracle-oci.autogenerated_1"]

  provisioner "shell" {
    script = "installer.sh"
  }

  provisioner "shell" {
    script = "cleanup.sh"
  }

}