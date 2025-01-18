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

run "flow_log_validation" {
  command = plan

  assert {
    condition     = var.enable_flow_log ? length(aws_flow_log.network_flow_logging) > 0 : length(aws_flow_log.network_flow_logging) == 0
    error_message = "Flow log creation should match enable_flow_log variable"
  }

  assert {
    condition     = var.enable_flow_log ? aws_flow_log.network_flow_logging[0].traffic_type == "ALL" : true
    error_message = "Flow log should capture ALL traffic"
  }

  assert {
    condition     = var.enable_flow_log ? aws_cloudwatch_log_group.network_flow_logging[0].retention_in_days == 365 : true
    error_message = "Log retention should be set to 365 days"
  }
}

run "flow_log_iam_validation" {
  command = apply

  assert {
    condition     = var.enable_flow_log ? jsondecode(aws_iam_role.vpc_flow_log_role[0].assume_role_policy).Statement[0].Principal.Service == "vpc-flow-logs.amazonaws.com" : true
    error_message = "Flow log IAM role should be assumable by vpc-flow-logs service"
  }

  assert {
    condition     = var.enable_flow_log ? contains(jsondecode(aws_iam_role.vpc_flow_log_role[0].assume_role_policy).Statement[*].Action, "sts:AssumeRole") : true
    error_message = "Flow log IAM role should allow sts:AssumeRole"
  }
}

run "flow_log_policy_validation" {
  command = plan

  assert {
    condition = var.enable_flow_log ? alltrue([
      for statement in jsondecode(aws_iam_role_policy.vpc_flow_log_role_policy[0].policy).Statement :
      contains(statement.Action, "logs:CreateLogStream")
    ]) : true
    error_message = "Flow log IAM policy should allow CreateLogStream"
  }

  assert {
    condition = var.enable_flow_log ? alltrue([
      for statement in jsondecode(aws_iam_role_policy.vpc_flow_log_role_policy[0].policy).Statement :
      statement.Effect == "Allow"
    ]) : true
    error_message = "Flow log IAM policy statements should have Allow effect"
  }
}

run "flow_log_permissions_validation" {
  command = plan

  assert {
    condition = var.enable_flow_log ? alltrue([
      for required_action in [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
        ] : anytrue([
          for statement in jsondecode(aws_iam_role_policy.vpc_flow_log_role_policy[0].policy).Statement :
          contains(statement.Action, required_action)
      ])
    ]) : true
    error_message = "Flow log IAM policy missing required permissions"
  }
}


run "kms_key_validation" {
  command = plan

  assert {
    condition     = var.enable_flow_log ? aws_kms_key.custom_kms_key[0].deletion_window_in_days == 7 : true
    error_message = "KMS key should have correct deletion window"
  }

  assert {
    condition     = var.enable_flow_log ? aws_kms_key.custom_kms_key[0].enable_key_rotation == true : true
    error_message = "KMS key rotation should be enabled"
  }

  assert {
    condition     = var.enable_flow_log ? contains(keys(aws_kms_key.custom_kms_key[0].tags), "Name") : true
    error_message = "KMS key should have Name tag"
  }
}

run "default_security_group_validation" {
  command = plan

  assert {
    condition     = length(aws_default_security_group.this.ingress) == 0
    error_message = "Default security group should have no ingress rules"
  }

  assert {
    condition     = length(aws_default_security_group.this.egress) == 0
    error_message = "Default security group should have no egress rules"
  }

  assert {
    condition     = contains(keys(aws_default_security_group.this.tags), "Name")
    error_message = "Default security group should have Name tag"
  }
}

run "cloudwatch_log_group_validation" {
  command = plan

  assert {
    condition     = var.enable_flow_log ? aws_cloudwatch_log_group.network_flow_logging[0].kms_key_id != null : true
    error_message = "CloudWatch Log Group should be encrypted with KMS"
  }

  assert {
    condition     = var.enable_flow_log ? contains(keys(aws_cloudwatch_log_group.network_flow_logging[0].tags), "Name") : true
    error_message = "CloudWatch Log Group should have Name tag"
  }
}

run "iam_role_naming_validation" {
  command = plan

  assert {
    condition     = var.enable_flow_log ? can(regex("^${local.vpc_name}-vpc-flow-role$", aws_iam_role.vpc_flow_log_role[0].name)) : true
    error_message = "IAM role name should follow naming convention"
  }

  assert {
    condition     = var.enable_flow_log ? can(regex("^${local.vpc_name}-vpc-flow-policy$", aws_iam_role_policy.vpc_flow_log_role_policy[0].name)) : true
    error_message = "IAM policy name should follow naming convention"
  }
}

run "flow_log_permissions_validation" {
  command = plan

  assert {
    condition = var.enable_flow_log ? alltrue([
      for action in [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ] : contains(jsondecode(data.aws_iam_policy_document.vpc_flow_log_policy_document[0].json).Statement[0].Action, action)
    ]) : true
    error_message = "Flow log IAM policy should have all required permissions"
  }
}

run "resource_dependencies_validation" {
  command = plan

  assert {
    condition     = var.enable_flow_log ? aws_flow_log.network_flow_logging[0].log_destination == aws_cloudwatch_log_group.network_flow_logging[0].arn : true
    error_message = "Flow log destination should match CloudWatch Log Group ARN"
  }

  assert {
    condition     = var.enable_flow_log ? aws_cloudwatch_log_group.network_flow_logging[0].kms_key_id == aws_kms_key.custom_kms_key[0].arn : true
    error_message = "CloudWatch Log Group should use the custom KMS key"
  }
}
