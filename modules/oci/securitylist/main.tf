resource "oci_core_security_list" "security_list" {
  compartment_id = var.compartment_id
  display_name   = var.name
  vcn_id         = var.vcn.id

  ingress_security_rules {
    protocol = var.ingress_iana_protocol_number
    source = var.ingress_source

    dynamic tcp_options {
      for_each = var.tcp_ingress_port == null ? toset([]) : toset([1])
      content {
        max = var.tcp_ingress_port
        min = var.tcp_ingress_port
      }
    }

    dynamic udp_options {
      for_each = var.udp_ingress_port == null ? toset([]) : toset([1])
      content {
        max = var.udp_ingress_port
        min = var.udp_ingress_port
      }
    }
  }
}
