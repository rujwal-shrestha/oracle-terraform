variable "compartment_id" {
  description = "OCI compartment OCID"
  type        = string
}

variable "vcn_name" {
  description = "VCN display name"
  type        = string
}

variable "vcn_cidr" {
  description = "VCN CIDR block"
  type        = string
}

variable "vcn_dns_label" {
  description = "VCN DNS label"
  type        = string
  default     = "production"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = true
}