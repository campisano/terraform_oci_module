data "template_file" "init_script" {
  count = var.init_script_path != null ? 1 : 0

  template = file(var.init_script_path)
}

resource "oci_core_instance" "instance" {
  compartment_id      = var.compartment_id
  display_name        = var.name
  availability_domain = var.ad_name
  shape               = var.instance_shape

  source_details {
    source_type             = "image"
    source_id               = var.image_ocid
    boot_volume_size_in_gbs = var.boot_disk_size
  }

  create_vnic_details {
    display_name     = "${var.name}-primary-vnic"
    subnet_id        = var.subnet_id
    assign_public_ip = var.static_ip
  }

  metadata = {
    ssh_authorized_keys = file(var.keypair_path)
    user_data           = var.init_script_path == null ? null : base64encode(data.template_file.init_script[0].rendered)
  }

  preserve_boot_volume = false
}
