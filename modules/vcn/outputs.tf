output "vcn_id" {
  description = "OCID of the VCN"
  value       = oci_core_vcn.this.id
}

output "vcn_cidr" {
  description = "VCN CIDR"
  value       = oci_core_vcn.this.cidr_blocks
}

output "public_subnet_id" {
  description = "OCID of public subnet"
  value       = oci_core_subnet.public.id
}

output "private_subnet_id" {
  description = "OCID of private subnet"
  value       = oci_core_subnet.private.id
}

output "internet_gateway_id" {
  description = "OCID of Internet Gateway"
  value       = oci_core_internet_gateway.this.id
}

output "nat_gateway_id" {
  description = "OCID of NAT Gateway"
  value       = var.enable_nat_gateway ? oci_core_nat_gateway.this[0].id : null
}