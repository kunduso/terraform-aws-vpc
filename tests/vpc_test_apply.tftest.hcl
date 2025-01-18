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
run "vpc_creation_apply" {
  command = apply

  assert {
    condition     = aws_vpc.this.state == "available"
    error_message = "VPC was not created successfully"
  }
}

run "subnet_creation_apply" {
  command = apply

  assert {
    condition     = alltrue([for subnet in aws_subnet.private : subnet.state == "available"])
    error_message = "Private subnets not in available state"
  }

  assert {
    condition     = alltrue([for subnet in aws_subnet.public : subnet.state == "available"])
    error_message = "Public subnets not in available state"
  }
}

run "nat_gateway_apply" {
  command = apply

  assert {
    condition     = var.enable_nat_gateway ? alltrue([for nat in aws_nat_gateway.public : nat.state == "available"]) : true
    error_message = "NAT Gateways not in available state"
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
    condition     = var.enable_flow_log ? aws_kms_key.custom_kms_key[0].key_state == "Enabled" : true
    error_message = "KMS key not in enabled state"
  }
}
