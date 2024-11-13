terraform {
  backend "s3" {
    bucket = "skundu-terraform-remote-state"
    key    = "tf/ADO-TF-VPC-Int/terraform.tfstate"
    region = "us-east-1"
  }
}