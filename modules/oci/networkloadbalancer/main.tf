resource "oci_network_load_balancer_network_load_balancer" "balancer" {
  compartment_id                 = var.compartment_id
  display_name                   = var.name
  subnet_id                      = var.subnet_id
  is_private                     = false
  is_preserve_source_destination = false
}

resource "oci_network_load_balancer_backend_set" "backend_set" {
  name                     = "${var.name}-backend-set"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.balancer.id
  policy                   = "FIVE_TUPLE"
  is_preserve_source = false

  health_checker {
    protocol = "TCP"
    port     = var.healthcheck_port
  }
}

resource "oci_network_load_balancer_listener" "listener" {
  name                     = "${var.name}-listener"
  default_backend_set_name = oci_network_load_balancer_backend_set.backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.balancer.id
  protocol                 = "TCP"
  port                     = var.listener_port
}

resource "oci_network_load_balancer_backend" "backend" {
  #  count                    = length(local.active_nodes)
  for_each = var.backend_instances

  name                     = "${var.name}-bakend-${each.key}"
  backend_set_name         = oci_network_load_balancer_backend_set.backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.balancer.id
  port                     = var.backend_port
  target_id                = each.value.id
}
