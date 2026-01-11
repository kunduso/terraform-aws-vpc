provider "aws" {
  region = "us-east-1"
}

# Test subnet-specific tags functionality
run "test_subnet_specific_tags" {
  command = apply

  variables {
    vpc_cidr            = "10.0.0.0/16"
    region              = "us-east-1"
    subnet_cidr_private = ["10.0.1.0/24", "10.0.2.0/24"]
    subnet_cidr_public  = ["10.0.11.0/24", "10.0.12.0/24"]

    # EKS-specific tags as mentioned in the issue
    public_subnet_tags = {
      "kubernetes.io/role/elb" = "1"
      "Environment"            = "test-public"
    }

    private_subnet_tags = {
      "kubernetes.io/role/internal-elb" = "1"
      "Environment"                     = "test-private"
    }

    tags = {
      "Project" = "vpc-module-test"
    }
  }

  assert {
    condition     = length(aws_subnet.private) == 2
    error_message = "Should create exactly 2 private subnets"
  }

  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "Should create exactly 2 public subnets"
  }

  # Test that private subnets have the correct tags
  assert {
    condition     = alltrue([for subnet in aws_subnet.private : subnet.tags["kubernetes.io/role/internal-elb"] == "1"])
    error_message = "All private subnets should have kubernetes.io/role/internal-elb tag"
  }

  assert {
    condition     = alltrue([for subnet in aws_subnet.private : subnet.tags["Environment"] == "test-private"])
    error_message = "All private subnets should have Environment=test-private tag"
  }

  # Test that public subnets have the correct tags
  assert {
    condition     = alltrue([for subnet in aws_subnet.public : subnet.tags["kubernetes.io/role/elb"] == "1"])
    error_message = "All public subnets should have kubernetes.io/role/elb tag"
  }

  assert {
    condition     = alltrue([for subnet in aws_subnet.public : subnet.tags["Environment"] == "test-public"])
    error_message = "All public subnets should have Environment=test-public tag"
  }

  # Test that global tags are still applied
  assert {
    condition     = alltrue([for subnet in aws_subnet.private : subnet.tags["Project"] == "vpc-module-test"])
    error_message = "All private subnets should have global Project tag"
  }

  assert {
    condition     = alltrue([for subnet in aws_subnet.public : subnet.tags["Project"] == "vpc-module-test"])
    error_message = "All public subnets should have global Project tag"
  }

  # Test that Name tags are still generated correctly
  assert {
    condition     = alltrue([for i, subnet in aws_subnet.private : contains(keys(subnet.tags), "Name")])
    error_message = "All private subnets should have Name tags"
  }

  assert {
    condition     = alltrue([for i, subnet in aws_subnet.public : contains(keys(subnet.tags), "Name")])
    error_message = "All public subnets should have Name tags"
  }
}

# Test backward compatibility - no subnet-specific tags provided
run "test_backward_compatibility" {
  command = plan

  variables {
    vpc_cidr            = "10.1.0.0/16"
    region              = "us-east-1"
    subnet_cidr_private = ["10.1.1.0/24"]
    subnet_cidr_public  = ["10.1.11.0/24"]

    tags = {
      "Project" = "backward-compatibility-test"
    }
  }

  assert {
    condition     = length(aws_subnet.private) == 1
    error_message = "Should create exactly 1 private subnet"
  }

  assert {
    condition     = length(aws_subnet.public) == 1
    error_message = "Should create exactly 1 public subnet"
  }

  # Test that subnets still get global tags and Name tags
  assert {
    condition     = aws_subnet.private[0].tags["Project"] == "backward-compatibility-test"
    error_message = "Private subnet should have global Project tag"
  }

  assert {
    condition     = aws_subnet.public[0].tags["Project"] == "backward-compatibility-test"
    error_message = "Public subnet should have global Project tag"
  }

  assert {
    condition     = contains(keys(aws_subnet.private[0].tags), "Name")
    error_message = "Private subnet should have Name tag"
  }

  assert {
    condition     = contains(keys(aws_subnet.public[0].tags), "Name")
    error_message = "Public subnet should have Name tag"
  }
}