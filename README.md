<!-- BEGIN_TF_DOCS -->
[![Build Status](https://littlecoding.visualstudio.com/Open-Project/_apis/build/status%2Fkunduso.terraform-aws-vpc?branchName=main)](https://littlecoding.visualstudio.com/Open-Project/_build/latest?definitionId=37&branchName=main) [![checkov-static-analysis-scan](https://github.com/kunduso/terraform-aws-vpc/actions/workflows/code-scan.yml/badge.svg?branch=main)](https://github.com/kunduso/terraform-aws-vpc/actions/workflows/code-scan.yml) [![Generate terraform docs](https://github.com/kunduso/terraform-aws-vpc/actions/workflows/documentation.yml/badge.svg)](https://github.com/kunduso/terraform-aws-vpc/actions/workflows/documentation.yml)
# Terraform Module for Amazon Virtual Private Cloud resources
This repository contains a Terraform module that automates the creation of Amazon Virtual Private Cloud (VPC) resources on AWS.

## Overview
This module provides foundation for setting up secure, isolated environments in AWS, including:
- Automated VPC creation with customizable CIDR blocks
- Public and private subnet configuration
- Network traffic logging and monitoring capabilities
- Built-in security best practices
- Configurable NAT gateways for private subnet access

#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement_aws) | >= 5.0.0 |
| <a name="requirement_random"></a> [random](#requirement_random) | >= 3.0.0 |

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider_aws) | >= 5.0.0 |
| <a name="provider_random"></a> [random](#provider_random) | >= 3.0.0 |



#### Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.network_flow_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_default_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_eip.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_flow_log.network_flow_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.vpc_flow_log_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.vpc_flow_log_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_internet_gateway.this_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_kms_alias.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.custom_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.encrypt_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_nat_gateway.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.internet_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.private_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [random_string.vpc_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input_region) | The AWS region to provision resources. | `string` | n/a | yes |
| <a name="input_enable_dns_hostnames"></a> [enable_dns_hostnames](#input_enable_dns_hostnames) | Enable DNS hostnames for VPC. | `bool` | `false` | no |
| <a name="input_enable_dns_support"></a> [enable_dns_support](#input_enable_dns_support) | Enable DNS support for VPC. | `bool` | `false` | no |
| <a name="input_enable_flow_log"></a> [enable_flow_log](#input_enable_flow_log) | Enable VPC flow logs | `bool` | `true` | no |
| <a name="input_enable_internet_gateway"></a> [enable_internet_gateway](#input_enable_internet_gateway) | Enable internet gateway for VPC. | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable_nat_gateway](#input_enable_nat_gateway) | Enable nat gateway for VPC. | `bool` | `false` | no |
| <a name="input_subnet_cidr_private"></a> [subnet_cidr_private](#input_subnet_cidr_private) | CIDR blocks for the private subnets. | `list(any)` | `[]` | no |
| <a name="input_subnet_cidr_public"></a> [subnet_cidr_public](#input_subnet_cidr_public) | CIDR blocks for the public subnets. | `list(any)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input_tags) | AWS Cloud resource tags. | `map(string)` | <pre>{<br/>  "Source": "https://github.com/kunduso/terraform-aws-vpc"<br/>}</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc_cidr](#input_vpc_cidr) | CIDR for the VPC. | `string` | `""` | no |
| <a name="input_vpc_name"></a> [vpc_name](#input_vpc_name) | Name of the VPC. | `string` | `""` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_cloudwatch_log_group"></a> [aws_cloudwatch_log_group](#output_aws_cloudwatch_log_group) | The CloudWatch Log Group (if enabled). |
| <a name="output_aws_iam_role"></a> [aws_iam_role](#output_aws_iam_role) | The IAM Role (if enabled). |
| <a name="output_flow_log"></a> [flow_log](#output_flow_log) | The flow log (if enabled). |
| <a name="output_iam_policy"></a> [iam_policy](#output_iam_policy) | The IAM Policy (if enabled). |
| <a name="output_internet_gateway"></a> [internet_gateway](#output_internet_gateway) | The Internet Gateway (if enabled). |
| <a name="output_internet_route"></a> [internet_route](#output_internet_route) | The Internet Gateway route (if enabled). |
| <a name="output_kms_key"></a> [kms_key](#output_kms_key) | The KMS Key to encrypt the AWS CloudWatch Logs (if enabled). |
| <a name="output_kms_key_alias"></a> [kms_key_alias](#output_kms_key_alias) | The alias of the KMS key (if enabled). |
| <a name="output_kms_key_policy"></a> [kms_key_policy](#output_kms_key_policy) | The IAM policy for the KMS key (if enabled). |
| <a name="output_nat_gateway"></a> [nat_gateway](#output_nat_gateway) | The NAT Gateway (if enabled). |
| <a name="output_nat_gateway_public_ips"></a> [nat_gateway_public_ips](#output_nat_gateway_public_ips) | List of public Elastic IPs created for NAT Gateway (if enabled). |
| <a name="output_private_route"></a> [private_route](#output_private_route) | The private route. |
| <a name="output_private_route_table"></a> [private_route_table](#output_private_route_table) | The priavte route tables created in this module. |
| <a name="output_private_route_table_association"></a> [private_route_table_association](#output_private_route_table_association) | The private route table association. |
| <a name="output_private_subnets"></a> [private_subnets](#output_private_subnets) | List of private subnets. |
| <a name="output_public_route_table"></a> [public_route_table](#output_public_route_table) | The public route table. |
| <a name="output_public_route_table_association"></a> [public_route_table_association](#output_public_route_table_association) | The public route table association. |
| <a name="output_public_subnets"></a> [public_subnets](#output_public_subnets) | List of public subnets. |
| <a name="output_vpc"></a> [vpc](#output_vpc) | The VPC created via this module. |

## Usage
To use this module in your Terraform configuration, include the following module block:

```hcl
module "vpc" {
  # source = "github.com/kunduso/terraform-aws-vpc?ref=v1.0.2"
  source                  = "../"
  region                  = var.region
  enable_internet_gateway = true
  enable_nat_gateway      = true
  vpc_cidr                = "10.20.30.0/24"
  subnet_cidr_public      = ["10.20.30.0/27", "10.20.30.32/27", "10.20.30.64/27"]
  subnet_cidr_private     = ["10.20.30.128/27", "10.20.30.160/27", "10.20.30.192/27"]
  tags = {
    Application_ID = "12345"
    Environment    = "dev"
    Source         = "https://github.com/kunduso/terraform-aws-vpc"
  }
  #CKV_TF_1: Ensure Terraform module sources use a commit hash
  #checkov:skip=CKV_TF_1: This is a self hosted module where the version number is tagged rather than the commit hash.
}
```
## Example Implementation
A complete example implementation of this module can be found in the [example directory](https://github.com/kunduso/terraform-aws-vpc/tree/main/example). The example demonstrates how to:

- Set up the AWS provider
- Configure the VPC module
- Define required variables
- Set up backend configuration

You can use this example as a reference for implementing the module in your own infrastructure code.
</br> Additionally, the repository includes [Azure Pipelines](https://github.com/kunduso/terraform-aws-vpc/blob/main/pipeline/azure-pipelines.yaml) to automate the deployment of this infrastructure as part of a CI/CD pipeline. This makes it easy to apply your Terraform configurations directly from the pipeline.

Note: Ensure you have appropriate AWS credentials configured before running the example.

## Contributing
If you find any issues or have suggestions for improvement, feel free to open an issue or submit a pull request. Contributions are always welcome!
## License
This code is released under the Unlicense License. See [LICENSE](https://github.com/kunduso/terraform-aws-vpc/blob/main/LICENSE).
<!-- END_TF_DOCS -->