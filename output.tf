output "oci_identity_compartment" {
  value = oci_identity_compartment.compartment.compartment_id
}

output "oci_instances" {
  value = {for key, val in module.oci_instance : key => val.instance.public_ip}
}

output "oci_loadbalancer" {
  value = {for key, val in module.oci_networkloadbalancer : key => [for subval in val.networkloadbalancer.ip_addresses : subval.ip_address if subval.is_public] }
}
