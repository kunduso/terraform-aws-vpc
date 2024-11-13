#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log
resource "aws_flow_log" "network_flow_logging" {
  count           = var.enable_flow_log ? 1 : 0
  iam_role_arn    = aws_iam_role.vpc_flow_log_role[0].arn
  log_destination = aws_cloudwatch_log_group.network_flow_logging[0].arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id
  tags = {
    "Name" = "${local.flow_log}"
  }
}

resource "aws_cloudwatch_log_group" "network_flow_logging" {
  count      = var.enable_flow_log ? 1 : 0
  name       = local.flow_log
  kms_key_id = aws_kms_key.custom_kms_key[0].arn
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "vpc_flow_log_role" {
  count              = var.enable_flow_log ? 1 : 0
  name               = "${local.vpc_name}-vpc-flow-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "vpc_flow_log_policy_document" {
  count = var.enable_flow_log ? 1 : 0
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]
    resources = [aws_cloudwatch_log_group.network_flow_logging[0].arn]
  }
}

resource "aws_iam_role_policy" "vpc_flow_log_role_policy" {
  count  = var.enable_flow_log ? 1 : 0
  name   = "${local.vpc_name}-vpc-flow-policy"
  role   = aws_iam_role.vpc_flow_log_role[0].id
  policy = data.aws_iam_policy_document.vpc_flow_log_policy_document[0].json
}