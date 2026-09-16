terraform {
  backend "oci" {
    namespace = "bm75uif4ptwz"
    bucket    = "rs-bucket"
    region    = "ap-mumbai-1"

    key = "tfstate/terraform.tfstate"
  }
}