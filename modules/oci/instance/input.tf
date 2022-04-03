variable "name"             { type = string }
variable "compartment_id"   { type = string }
variable "subnet_id"        { type = string }
variable "ad_name"          { type = string }
variable "keypair_path"     { type = string }
variable "instance_shape"   { type = string }
variable "shape_ocpus"      {
  type = string
  default = null
}
variable "shape_mem"        {
  type = string
  default = null
}
variable "image_ocid"       { type = string }
variable "boot_disk_size"   { type = string }
variable "static_ip"        {
  type = bool
  default = false
}
variable "init_script_path" {
  type = string
  default = null
}
