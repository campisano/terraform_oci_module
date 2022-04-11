resource "oci_core_subnet" "subnet" {
  compartment_id      = var.compartment_id
  display_name        = var.name
  availability_domain = var.ad_name
  cidr_block          = var.cidr_block
  security_list_ids   = concat([var.vcn.default_security_list_id], var.security_list_ids)
  vcn_id              = var.vcn.id
  route_table_id      = var.vcn.default_route_table_id
  dhcp_options_id     = var.vcn.default_dhcp_options_id
}
