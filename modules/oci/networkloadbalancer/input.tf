variable "name"              { type = string }
variable "compartment_id"    { type = string }
variable "subnet_id"         { type = string }
variable "listener_port"     { type = number }
variable "healthcheck_port"  { type = number }
variable "backend_port"      { type = number }
variable "backend_instances" { type = map(any) }
