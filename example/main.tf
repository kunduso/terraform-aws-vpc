module "vpc" {
  source = "github.com/kunduso/terraform-aws-vpc?ref=v1.0.0"
  region = var.region
}