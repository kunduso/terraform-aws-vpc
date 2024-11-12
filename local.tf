locals {
  vpc_name = var.vpc_name == "" ? "vpc-${random_string.vpc_name[0].result}" : var.vpc_name
}