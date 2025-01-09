module "vpc" {
  # source = "github.com/kunduso/terraform-aws-vpc?ref=v1.0.3"
  source                  = "../"
  region                  = var.region
  enable_internet_gateway = true
  enable_nat_gateway      = true
  vpc_cidr                = "10.20.30.0/24"
  subnet_cidr_public      = ["10.20.30.0/27", "10.20.30.32/27", "10.20.30.64/27"]
  subnet_cidr_private     = ["10.20.30.128/27", "10.20.30.160/27", "10.20.30.192/27"]
  tags = {
    Application_ID = "12345"
    Environment    = "dev"
    Source         = "https://github.com/kunduso/terraform-aws-vpc"
  }
  #CKV_TF_1: Ensure Terraform module sources use a commit hash
  #checkov:skip=CKV_TF_1: This is a self hosted module where the version number is tagged rather than the commit hash.
}