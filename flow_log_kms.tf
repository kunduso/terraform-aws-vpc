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
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias
resource "aws_kms_alias" "key" {
  count         = var.enable_flow_log ? 1 : 0
  name          = "alias/${local.vpc_name}"
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
        Sid = "Enable IAM User Permissions"
        Action = [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ]
        Effect = "Allow"
        Principal = {
          AWS = "${local.principal_root_arn}"
        }
        Resource = "*"
      },
      {
        Sid    = "AllowCloudWatchLogsEncryption"
        Effect = "Allow"
        Principal = {
          Service = "${local.principal_logs_arn}"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncryptFrom",
          "kms:ReEncryptTo",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = "*"
        Condition = {
          ArnEquals = {
            "kms:EncryptionContext:aws:logs:arn" = [local.flow_log_group_arn]
          }
        }
      }
    ]
    Version = "2012-10-17"
  })
}
