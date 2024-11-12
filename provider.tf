terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

# provider "aws" {
#   region     = var.region
#   access_key = var.access_key
#   secret_key = var.secret_key
# }

# provider "random" {}