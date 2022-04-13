data "oci_identity_availability_domain" "ad" {
  compartment_id = var.oci_provider.tenancy_ocid
  ad_number      = 1
}

resource "oci_identity_compartment" "compartment" {
  compartment_id = var.oci_provider.tenancy_ocid
  name           = "tf-compartment"
  description    = "compartment created by terraform"
  enable_delete  = true
}

module "oci_vcn" {
  source = "./modules/oci/vcn"

  for_each = var.oci_vcn_module

  name           = each.key
  compartment_id = oci_identity_compartment.compartment.compartment_id
  cidr_block     = each.value.cidr_block
}

module "oci_securitylist" {
  source = "./modules/oci/securitylist"

  for_each = var.oci_securitylist_module

  name                         = each.key
  compartment_id               = oci_identity_compartment.compartment.compartment_id
  vcn                          = module.oci_vcn[each.value.vcn_name].vcn
  ingress_iana_protocol_number = each.value.ingress_iana_protocol_number
  ingress_source               = each.value.ingress_source
  tcp_ingress_port             = lookup(each.value, "tcp_ingress_port", null)
  udp_ingress_port             = lookup(each.value, "udp_ingress_port", null)
}

module "oci_subnet" {
  source = "./modules/oci/subnet"

  for_each = var.oci_subnet_module

  name              = each.key
  compartment_id    = oci_identity_compartment.compartment.compartment_id
  vcn               = module.oci_vcn[each.value.vcn_name].vcn
  ad_name           = data.oci_identity_availability_domain.ad.name
  cidr_block        = each.value.cidr_block
  security_list_ids = [for sl_name in each.value.securitylists: module.oci_securitylist[sl_name].securitylist.id]
}

module "oci_instance" {
  source = "./modules/oci/instance"

  for_each = var.oci_instance_module

  name             = each.key
  compartment_id   = oci_identity_compartment.compartment.compartment_id
  subnet_id        = module.oci_subnet[each.value.subnet_name].subnet.id
  ad_name          = data.oci_identity_availability_domain.ad.name
  keypair_path     = each.value.keypair_path
  instance_shape   = each.value.instance_shape
  shape_ocpus      = lookup(each.value, "shape_ocpus", null)
  shape_mem        = lookup(each.value, "shape_mem", null)
  image_ocid       = each.value.image_ocid
  boot_disk_size   = lookup(each.value, "boot_disk_size", null)
  static_ip        = lookup(each.value, "static_ip", false)
  init_script_path = lookup(each.value, "init_script_path", null)
}

module "oci_networkloadbalancer" {
  source = "./modules/oci/networkloadbalancer"

  for_each = var.oci_networkloadbalancer_module

  name              = each.key
  compartment_id    = oci_identity_compartment.compartment.compartment_id
  subnet_id         = module.oci_subnet[each.value.subnet_name].subnet.id
  listener_port     = each.value.listener_port
  healthcheck_port  = each.value.healthcheck_port
  backend_port      = each.value.backend_port
  backend_instances = {for i_name in each.value.backend_instances: i_name => module.oci_instance[i_name].instance}
}
