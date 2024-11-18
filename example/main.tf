module "vpc" {
  source = "github.com/kunduso/terraform-aws-vpc?ref=v1.0.1"
  region = var.region
  #CKV_TF_1: Ensure Terraform module sources use a commit hash
  #checkov:skip=CKV_TF_1: This is a self hosted module where the version number is tagged rather than the commit hash.
}