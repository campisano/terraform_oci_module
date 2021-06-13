output "static_ip" {
  value = oci_core_instance.instance.public_ip
}
