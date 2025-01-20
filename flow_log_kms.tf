data "aws_caller_identity" "current" {}
locals {
  flow_log           = "${local.vpc_name}-flow-logs"
  principal_root_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  principal_logs_arn = "logs.${var.region}.amazonaws.com"
  flow_log_group_arn = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:${local.flow_log}"
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key
resource "aws_kms_key" "custom_kms_key" {
  count                   = var.enable_flow_log ? 1 : 0
  description             = "KMS key for ${local.vpc_name}"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  #checkov:skip=CKV2_AWS_64: "Ensure KMS key Policy is defined"
  #KMS Key policy is defined as aws_kms_key_policy encrypt_log {}
  tags = merge({ Name = "${local.vpc_name}-encryption-key" }, var.tags)
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias
resource "aws_kms_alias" "key" {
  count         = var.enable_flow_log ? 1 : 0
  name          = "alias/${local.vpc_name}-encrypt-flow-log"
  target_key_id = aws_kms_key.custom_kms_key[0].id
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy
resource "aws_kms_key_policy" "encrypt_log" {
  count  = var.enable_flow_log ? 1 : 0
  key_id = aws_kms_key.custom_kms_key[0].id
  policy = jsonencode({
    Id = "${local.vpc_name}-flow-log-encryption"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Action = ["kms:*"]
        Effect = "Allow"
        Principal = {
          AWS = local.principal_root_arn
        }
        Resource = "*"
      },
      {
        Sid    = "AllowCloudWatchLogsEncryption"
        Effect = "Allow"
        Principal = {
          Service = local.principal_logs_arn
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowCloudWatchLogsEncryptionContext"
        Effect = "Allow"
        Principal = {
          Service = local.principal_logs_arn
        }
        Action = [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ]
        Resource = "*"
        Condition = {
          Bool = {
            "kms:GrantIsForAWSResource" : "true"
          }
        }
      }
    ]
    Version = "2012-10-17"
  })
}