output "oci_identity_compartment" {
  value = oci_identity_compartment.compartment.compartment_id
}

output "oci_instances" {
  value = {for key, val in module.oci_instance : key => val.instance.public_ip}
}
