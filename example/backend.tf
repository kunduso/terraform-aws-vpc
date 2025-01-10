terraform {
  backend "s3" {
    bucket       = "kunduso-terraform-remote-bucket"
    encrypt      = true
    key          = "tf/terraform-aws-vpc/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
  }
}