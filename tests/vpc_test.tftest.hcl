provider "aws" {
  region = "us-east-1"
}
variables {
  vpc_name                = "test-vpc"
  vpc_cidr                = "10.0.0.0/16"
  region                  = "us-east-1"
  enable_dns_support      = true
  enable_dns_hostnames    = true
  subnet_cidr_private     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_cidr_public      = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway      = true
  enable_internet_gateway = true
  tags = {
    Environment = "test"
    Terraform   = "true"
  }
  access_key = ""
  secret_key = ""
}

run "vpc_creation" {
  command = plan

  assert {
    condition     = aws_vpc.this.cidr_block == var.vpc_cidr
    error_message = "VPC CIDR block does not match expected value"
  }

  assert {
    condition     = aws_vpc.this.enable_dns_support == var.enable_dns_support
    error_message = "VPC DNS support setting does not match expected value"
  }

  assert {
    condition     = aws_vpc.this.enable_dns_hostnames == var.enable_dns_hostnames
    error_message = "VPC DNS hostnames setting does not match expected value"
  }
}

run "subnet_creation" {
  command = plan

  assert {
    condition     = length(aws_subnet.private) == length(var.subnet_cidr_private)
    error_message = "Number of private subnets does not match expected value"
  }

  assert {
    condition     = length(aws_subnet.public) == length(var.subnet_cidr_public)
    error_message = "Number of public subnets does not match expected value"
  }
}

run "route_table_creation" {
  command = plan

  assert {
    condition     = length(aws_route_table.private) == length(var.subnet_cidr_private)
    error_message = "Number of private route tables does not match expected value"
  }

  assert {
    condition     = length(aws_route_table.public) == 1
    error_message = "Expected exactly one public route table"
  }
}

run "nat_gateway_creation" {
  command = plan

  assert {
    condition     = length(aws_nat_gateway.public) == length(var.subnet_cidr_public)
    error_message = "Number of NAT gateways does not match expected value"
  }

  assert {
    condition     = length(aws_eip.nat_gateway) == length(var.subnet_cidr_public)
    error_message = "Number of EIPs does not match expected value"
  }
}

run "internet_gateway_creation" {
  command = plan

  assert {
    condition     = length(aws_internet_gateway.this_igw) == 1
    error_message = "Expected exactly one Internet Gateway"
  }
}
