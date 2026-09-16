module "vcn" {
  source = "./modules/vcn"

  compartment_id      = var.compartment_id
  vcn_name             = var.vcn_name
  vcn_cidr             = var.vcn_cidr
  vcn_dns_label        = var.vcn_dns_label
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidr  = var.private_subnet_cidr
  enable_nat_gateway   = var.enable_nat_gateway
}