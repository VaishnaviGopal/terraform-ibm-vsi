terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
    }
  }
}

provider "ibm" {
}

resource "ibm_is_vpc" "vpc1" {
  name = "eg-vpc1"
}

resource "ibm_is_subnet" "subnet1" {
  name            = "eg-subnet1"
  vpc             = ibm_is_vpc.vpc1.id
  zone            = var.zone1
  ipv4_cidr_block = "10.240.0.0/28"
}

resource "ibm_is_subnet" "subnet2" {
  name            = "eg-subnet2"
  vpc             = ibm_is_vpc.vpc1.id
  zone            = var.zone2
  ipv4_cidr_block = "10.240.64.0/28"
}

resource "ibm_is_ssh_key" "sshkey" {
  name       = "eg-ssh1"
  public_key = var.ssh_public_key
}

resource "ibm_is_instance" "instance1" {
  name    = "eg-instance1"
  image   = var.image
  profile = var.profile

  primary_network_interface {
    subnet = ibm_is_subnet.subnet1.id
  }

  vpc       = ibm_is_vpc.vpc1.id
  zone      = var.zone1
  keys      = [ibm_is_ssh_key.sshkey.id]
}

resource "ibm_is_instance" "instance2" {
  name    = "eg-instance2"
  image   = var.image
  profile = var.profile

  primary_network_interface {
    subnet = ibm_is_subnet.subnet2.id
  }

  vpc       = ibm_is_vpc.vpc1.id
  zone      = var.zone2
  keys      = [ibm_is_ssh_key.sshkey.id]
}


variable "zone1" {
  default = "us-south-1"
}

variable "zone2" {
  default = "us-south-2"
}

variable "ssh_public_key" {
  default = ""
}

variable "image" {
  default = "r006-ed3f775f-ad7e-4e37-ae62-7199b4988b00"
}

variable "profile" {
  default = "cx2-2x4"
}
