resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_id

  display_name = var.vcn_name
  cidr_blocks  = [var.vcn_cidr]

  dns_label = var.vcn_dns_label
}

# -------------------------
# Internet Gateway
# -------------------------

resource "oci_core_internet_gateway" "this" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id

  display_name = "${var.vcn_name}-igw"
  enabled      = true
}

# -------------------------
# NAT Gateway
# -------------------------

resource "oci_core_nat_gateway" "this" {
  count = var.enable_nat_gateway ? 1 : 0

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id

  display_name = "${var.vcn_name}-nat"
}

# -------------------------
# Public Route Table
# -------------------------

resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id

  display_name = "${var.vcn_name}-public-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.this.id
  }
}

# -------------------------
# Private Route Table
# -------------------------

resource "oci_core_route_table" "private" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id

  display_name = "${var.vcn_name}-private-rt"

  dynamic "route_rules" {
    for_each = var.enable_nat_gateway ? [1] : []

    content {
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = oci_core_nat_gateway.this[0].id
    }
  }
}

# -------------------------
# Public Security List
# -------------------------

resource "oci_core_security_list" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id

  display_name = "${var.vcn_name}-public-sl"

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 443
      max = 443
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

# -------------------------
# Private Security List
# -------------------------

resource "oci_core_security_list" "private" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id

  display_name = "${var.vcn_name}-private-sl"

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

# -------------------------
# Public Subnet
# -------------------------

resource "oci_core_subnet" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id

  display_name = "${var.vcn_name}-public-subnet"

  cidr_block = var.public_subnet_cidr

  route_table_id    = oci_core_route_table.public.id
  security_list_ids = [oci_core_security_list.public.id]

  dns_label = "public"
}

# -------------------------
# Private Subnet
# -------------------------

resource "oci_core_subnet" "private" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id

  display_name = "${var.vcn_name}-private-subnet"

  cidr_block = var.private_subnet_cidr

  route_table_id = oci_core_route_table.private.id

  security_list_ids = [
    oci_core_security_list.private.id
  ]

  dns_label = "private"

  prohibit_public_ip_on_vnic = true
}