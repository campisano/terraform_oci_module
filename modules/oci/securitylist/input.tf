variable "name"                         { type = string }
variable "compartment_id"               { type = string }
variable "vcn"                          { type = any }
variable "ingress_iana_protocol_number" { type = string }
variable "ingress_source"               { type = string }
variable "tcp_ingress_port"             {
  type = number
  default = null
}
variable "udp_ingress_port"             {
  type = number
  default = null
}
