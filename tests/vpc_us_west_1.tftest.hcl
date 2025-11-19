provider "aws" {
  region = "us-west-1"
}

# Test the original failing case - 3 subnets in us-west-1 (2 AZs)
run "test_us_west_1_fix" {
  command = plan
  
  variables {
    vpc_cidr            = "10.20.30.0/24"
    region              = "us-west-1"
    subnet_cidr_private = ["10.20.30.128/27", "10.20.30.160/27", "10.20.30.192/27"]
    subnet_cidr_public  = ["10.20.30.0/27", "10.20.30.32/27", "10.20.30.64/27"]
  }

  assert {
    condition     = length(aws_subnet.private) == 3
    error_message = "Should create exactly 3 private subnets"
  }

  assert {
    condition     = length(aws_subnet.public) == 3
    error_message = "Should create exactly 3 public subnets"
  }

  assert {
    condition     = length(distinct([for s in aws_subnet.private : s.availability_zone])) <= 2
    error_message = "Private subnets should use at most 2 AZs in us-west-1"
  }

  assert {
    condition     = length(distinct([for s in aws_subnet.public : s.availability_zone])) <= 2
    error_message = "Public subnets should use at most 2 AZs in us-west-1"
  }
}

# Test with 4 subnets in us-west-1 - should cycle AZ1, AZ2, AZ1, AZ2
run "test_us_west_1_4_subnets" {
  command = plan
  
  variables {
    vpc_cidr            = "10.5.0.0/16"
    region              = "us-west-1"
    subnet_cidr_private = ["10.5.1.0/24", "10.5.2.0/24", "10.5.3.0/24", "10.5.4.0/24"]
    subnet_cidr_public  = ["10.5.11.0/24", "10.5.12.0/24", "10.5.13.0/24", "10.5.14.0/24"]
  }

  assert {
    condition     = length(aws_subnet.private) == 4
    error_message = "Should create exactly 4 private subnets"
  }

  assert {
    condition     = length(distinct([for s in aws_subnet.private : s.availability_zone])) == 2
    error_message = "Should use exactly 2 AZs in us-west-1"
  }
}