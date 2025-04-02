provider "aws" {
  region = "us-east-1"
}
variables {
  vpc_name                = "test-vpc-minimal"
  vpc_cidr                = "172.16.0.0/16"
  region                  = "us-east-1"
  enable_dns_support      = false
  enable_dns_hostnames    = false
  subnet_cidr_private     = []
  subnet_cidr_public      = []
  enable_nat_gateway      = false
  enable_internet_gateway = false
  tags = {
    Environment = "test"
  }
  access_key = ""
  secret_key = ""
}

run "vpc_minimal_creation" {
  command = plan
  assert {
    condition     = aws_vpc.this.cidr_block == var.vpc_cidr
    error_message = "VPC CIDR block does not match expected value"
  }
  assert {
    condition     = aws_vpc.this.enable_dns_support == false
    error_message = "VPC DNS support should be disabled"
  }

  assert {
    condition     = aws_vpc.this.enable_dns_hostnames == false
    error_message = "VPC DNS hostnames should be disabled"
  }
}

run "vpc_minimal_validation" {
  command = plan
  variables {
    enable_dns_hostnames = true
    enable_dns_support   = true
  }

  assert {
    condition     = aws_vpc.this.enable_dns_support == true
    error_message = "DNS support should be enabled by default"
  }

  assert {
    condition     = aws_vpc.this.enable_dns_hostnames == true
    error_message = "DNS hostnames should be enabled by default"
  }

  # Check IPv6 is not configured
  assert {
    condition     = aws_vpc.this.ipv6_cidr_block == ""
    error_message = "IPv6 CIDR block should not be assigned in minimal configuration"
  }

  assert {
    condition     = aws_vpc.this.ipv6_association_id == ""
    error_message = "No IPv6 association should exist in minimal configuration"
  }

  # Verify tags
  assert {
    condition     = contains(keys(aws_vpc.this.tags), "Name")
    error_message = "VPC should have a Name tag"
  }

  assert {
    condition     = aws_vpc.this.tags["Name"] == var.vpc_name
    error_message = "VPC Name tag should match vpc_name variable"
  }
}
run "no_subnets" {
  command = plan

  assert {
    condition     = length(aws_subnet.private) == 0
    error_message = "No private subnets should be created"
  }

  assert {
    condition     = length(aws_subnet.public) == 0
    error_message = "No public subnets should be created"
  }
}

run "no_gateways" {
  command = plan

  assert {
    condition     = length(aws_internet_gateway.this_igw) == 0
    error_message = "No Internet Gateway should be created"
  }

  assert {
    condition     = length(aws_nat_gateway.public) == 0
    error_message = "No NAT Gateways should be created"
  }
}
