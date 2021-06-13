resource "oci_core_vcn" "vcn" {
  compartment_id = var.compartment_id
  display_name   = var.name
  cidr_block     = var.cidr_block
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_id
  display_name   = "${var.name}-internet-gateway"
  vcn_id         = oci_core_vcn.vcn.id
}

resource "oci_core_default_route_table" "default_route_table" {
  display_name               = "${var.name}-default-route-table"
  manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}
