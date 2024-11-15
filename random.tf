#https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/auth.html#auth-overview
#https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
resource "random_string" "vpc_name" {
  count   = var.vpc_name == "" ? 1 : 0
  length  = 5
  special = false
  upper   = false
}