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
  enable_flow_log         = true
  tags = {
    Environment = "test"
    Terraform   = "true"
  }
  access_key = ""
  secret_key = ""
}
run "vpc_creation_apply" {
  command = apply

  assert {
    condition     = aws_vpc.this.id != ""
    error_message = "VPC was not created successfully"
  }

  assert {
    condition     = aws_vpc.this.arn != ""
    error_message = "VPC ARN is not available"
  }
}

run "subnet_creation_apply" {
  command = apply

  assert {
    condition     = alltrue([for subnet in aws_subnet.private : subnet.id != ""])
    error_message = "Private subnets not created successfully"
  }

  assert {
    condition     = alltrue([for subnet in aws_subnet.public : subnet.id != ""])
    error_message = "Public subnets not created successfully"
  }
}

run "nat_gateway_apply" {
  command = apply

  assert {
    condition     = var.enable_nat_gateway ? alltrue([for nat in aws_nat_gateway.public : nat.id != ""]) : true
    error_message = "NAT Gateways not created successfully"
  }
}

run "flow_logs_apply" {
  command = apply

  assert {
    condition     = var.enable_flow_log ? aws_flow_log.network_flow_logging[0].id != "" : true
    error_message = "Flow logs not created successfully"
  }
}

run "kms_key_apply" {
  command = apply

  assert {
    condition     = var.enable_flow_log ? aws_kms_key.custom_kms_key[0].id != "" : true
    error_message = "KMS key not created successfully"
  }

  assert {
    condition     = var.enable_flow_log ? aws_kms_key.custom_kms_key[0].arn != "" : true
    error_message = "KMS key ARN not available"
  }
}

run "route_tables_apply" {
  command = apply

  assert {
    condition     = alltrue([for rt in aws_route_table.private : rt.id != ""])
    error_message = "Private route tables not created successfully"
  }

  assert {
    condition     = length(aws_route_table.public) > 0 ? aws_route_table.public[0].id != "" : true
    error_message = "Public route table not created successfully"
  }
}

run "internet_gateway_apply" {
  command = apply

  assert {
    condition     = var.enable_internet_gateway ? aws_internet_gateway.this_igw[0].id != "" : true
    error_message = "Internet Gateway not created successfully"
  }
}