provider "aws" {
  region = "us-east-1"
}

# Test with 2 subnets - should distribute across 2 AZs
run "test_2_subnets" {
  command = plan
  
  variables {
    vpc_cidr            = "10.0.0.0/16"
    region              = "us-east-1"
    subnet_cidr_private = ["10.0.1.0/24", "10.0.2.0/24"]
    subnet_cidr_public  = ["10.0.11.0/24", "10.0.12.0/24"]
  }

  assert {
    condition     = length(aws_subnet.private) == 2
    error_message = "Should create exactly 2 private subnets"
  }

  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "Should create exactly 2 public subnets"
  }

  assert {
    condition     = length(distinct([for s in aws_subnet.private : s.availability_zone])) <= 2
    error_message = "Private subnets should be distributed across at most 2 AZs"
  }
}

# Test with 3 subnets - should distribute across 3 AZs
run "test_3_subnets" {
  command = plan
  
  variables {
    vpc_cidr            = "10.1.0.0/16"
    region              = "us-east-1"
    subnet_cidr_private = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
    subnet_cidr_public  = ["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"]
  }

  assert {
    condition     = length(aws_subnet.private) == 3
    error_message = "Should create exactly 3 private subnets"
  }

  assert {
    condition     = length(distinct([for s in aws_subnet.private : s.availability_zone])) == 3
    error_message = "Private subnets should be distributed across exactly 3 AZs"
  }
}

# Test with 4 subnets - should cycle through 3 AZs (AZ1, AZ2, AZ3, AZ1)
run "test_4_subnets" {
  command = plan
  
  variables {
    vpc_cidr            = "10.2.0.0/16"
    region              = "us-east-1"
    subnet_cidr_private = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24", "10.2.4.0/24"]
    subnet_cidr_public  = ["10.2.11.0/24", "10.2.12.0/24", "10.2.13.0/24", "10.2.14.0/24"]
  }

  assert {
    condition     = length(aws_subnet.private) == 4
    error_message = "Should create exactly 4 private subnets"
  }

  assert {
    condition     = length(distinct([for s in aws_subnet.private : s.availability_zone])) <= 3
    error_message = "Private subnets should use at most 3 AZs"
  }
}

# Test with 5 subnets - should cycle through 3 AZs (AZ1, AZ2, AZ3, AZ1, AZ2)
run "test_5_subnets" {
  command = plan
  
  variables {
    vpc_cidr            = "10.3.0.0/16"
    region              = "us-east-1"
    subnet_cidr_private = ["10.3.1.0/24", "10.3.2.0/24", "10.3.3.0/24", "10.3.4.0/24", "10.3.5.0/24"]
    subnet_cidr_public  = ["10.3.11.0/24", "10.3.12.0/24", "10.3.13.0/24", "10.3.14.0/24", "10.3.15.0/24"]
  }

  assert {
    condition     = length(aws_subnet.private) == 5
    error_message = "Should create exactly 5 private subnets"
  }

  assert {
    condition     = length(distinct([for s in aws_subnet.private : s.availability_zone])) <= 3
    error_message = "Private subnets should use at most 3 AZs"
  }
}

# Test with 6 subnets - should cycle through 3 AZs (AZ1, AZ2, AZ3, AZ1, AZ2, AZ3)
run "test_6_subnets" {
  command = plan
  
  variables {
    vpc_cidr            = "10.4.0.0/16"
    region              = "us-east-1"
    subnet_cidr_private = ["10.4.1.0/24", "10.4.2.0/24", "10.4.3.0/24", "10.4.4.0/24", "10.4.5.0/24", "10.4.6.0/24"]
    subnet_cidr_public  = ["10.4.11.0/24", "10.4.12.0/24", "10.4.13.0/24", "10.4.14.0/24", "10.4.15.0/24", "10.4.16.0/24"]
  }

  assert {
    condition     = length(aws_subnet.private) == 6
    error_message = "Should create exactly 6 private subnets"
  }

  assert {
    condition     = length(distinct([for s in aws_subnet.private : s.availability_zone])) <= 3
    error_message = "Private subnets should use at most 3 AZs"
  }
}