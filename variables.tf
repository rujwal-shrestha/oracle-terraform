variable "compartment_id" {
  type = string
}

variable "vcn_name" {
  type = string
}

variable "vcn_cidr" {
  type = string
}

variable "vcn_dns_label" {
  type    = string
  default = "production"
}

variable "public_subnet_cidr" {
  type = string
}

# variable "private_subnet_cidr" {
#   type = string
# }

# variable "enable_nat_gateway" {
#   type    = bool
#   default = false
# }