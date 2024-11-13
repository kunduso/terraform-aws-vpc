# VPC
output "vpc" {
  description = "The VPC created via this module."
  value       = aws_vpc.this
}

# Public Subnets
output "public_subnets" {
  description = "List of public subnets."
  value       = aws_subnet.public[*]
}
output "public_route_table" {
  description = "The public route table."
  value       = aws_route_table.public
}
output "private_route_table" {
  description = "The priavte route tables created in this module."
  value       = aws_route_table.private[*]
}
# Private Subnets
output "private_subnets" {
  description = "List of private subnets."
  value       = aws_subnet.private[*]
}

output "public_route_table_association" {
  description = "The public route table association."
  value       = aws_route_table_association.public
}
output "private_route_table_association" {
  description = "The private route table association."
  value       = aws_route_table_association.private[*]
}
# Internet Gateway
output "internet_gateway" {
  description = "The Internet Gateway (if enabled)."
  value       = var.enable_internet_gateway ? aws_internet_gateway.this_igw : null
}

output "internet_route" {
  description = "The Internet Gateway route (if enabled)."
  value       = var.enable_internet_gateway ? aws_route.internet_route : null
}
# NAT Gateway
output "nat_gateway" {
  description = "The NAT Gateway (if enabled)."
  value       = (var.enable_nat_gateway && var.enable_internet_gateway) ? aws_nat_gateway.public[*] : null
}

output "nat_gateway_public_ips" {
  description = "List of public Elastic IPs created for NAT Gateway (if enabled)."
  value       = (var.enable_nat_gateway && var.enable_internet_gateway) ? aws_eip.nat_gateway[*] : null
}
output "private_route" {
  description = "The private route."
  value       = (var.enable_nat_gateway && var.enable_internet_gateway) ? aws_route.private_route[*] : null
}
# Flow Logs (if enabled)
output "flow_log" {
  description = "The flow log (if enabled)."
  value       = var.enable_flow_log ? aws_flow_log.network_flow_logging[*] : null
}

output "aws_cloudwatch_log_group" {
  description = "The CloudWatch Log Group (if enabled)."
  value       = var.enable_flow_log ? aws_cloudwatch_log_group.network_flow_logging[*] : null
}

output "aws_iam_role" {
  description = "The IAM Role (if enabled)."
  value       = var.enable_flow_log ? aws_iam_role.vpc_flow_log_role[*] : null
}

output "iam_policy" {
  description = "The IAM Policy (if enabled)."
  value       = var.enable_flow_log ? aws_iam_role_policy.vpc_flow_log_role_policy[*] : null
}

output "kms_key" {
  description = "The KMS Key to encrypt the AWS CloudWatch Logs (if enabled)."
  value       = var.enable_flow_log ? aws_kms_key.custom_kms_key[*] : null
}

output "kms_key_alias" {
  description = "The alias of the KMS key (if enabled)."
  value       = var.enable_flow_log ? aws_kms_alias.key[*] : null
}

output "kms_key_policy" {
  description = "The IAM policy for the KMS key (if enabled)."
  value       = var.enable_flow_log ? aws_kms_key_policy.encrypt_log[*] : null
}