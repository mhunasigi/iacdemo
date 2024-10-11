terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_core_vcn" "VCN1" {
  cidr_blocks                      = ["10.10.0.0/16"]
  is_ipv6enabled                   = "true"
  is_oracle_gua_allocation_enabled = "true"
  display_name                     = "VCN1"
  dns_label                        = "VCN1"
  compartment_id                   = "ocid1.compartment.oc1..aaaaaaaa5qwf3ebzs2zhyhkd4linmzgnbdxve233m36xyzdfi2ae44utzira"
}

resource "oci_core_subnet" "pubsubnet" {
  cidr_block                 = cidrsubnet(oci_core_vcn.VCN1.cidr_blocks[0],8,1)
  ipv6cidr_block             = cidrsubnet(oci_core_vcn.VCN1.ipv6cidr_blocks[0], 8, 0)
  compartment_id             = "ocid1.compartment.oc1..aaaaaaaa5qwf3ebzs2zhyhkd4linmzgnbdxve233m36xyzdfi2ae44utzira"
  vcn_id                     = oci_core_vcn.VCN1.id
  prohibit_public_ip_on_vnic = "false"
  dns_label                  = "pubsubnet"
  display_name               = "pubsubnet"
}

output "IPv6" {
  value = cidrsubnets(oci_core_vcn.VCN1.ipv6cidr_blocks[0], 8, 8)
}

output "pubsubnet_cidrblock" {
  value = oci_core_subnet.pubsubnet.ipv6cidr_block
}
