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

  assert {
    condition     = aws_vpc.this.enable_classiclink == null
    error_message = "Classic Link should not be enabled in minimal VPC"
  }

  assert {
    condition     = aws_vpc.this.assign_generated_ipv6_cidr_block == false
    error_message = "IPv6 CIDR block should not be assigned in minimal configuration"
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
