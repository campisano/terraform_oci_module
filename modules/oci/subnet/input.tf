variable "name"              { type = string }
variable "compartment_id"    { type = string }
variable "vcn"               { type = any }
variable "ad_name"           { type = string }
variable "cidr_block"        { type = string }
variable "security_list_ids" { type = list(string) }
