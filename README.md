[![Build Status](https://littlecoding.visualstudio.com/Open-Project/_apis/build/status%2Fkunduso.terraform-aws-vpc?branchName=main)](https://littlecoding.visualstudio.com/Open-Project/_build/latest?definitionId=37&branchName=main) [![checkov-static-analysis-scan](https://github.com/kunduso/terraform-aws-vpc/actions/workflows/code-scan.yml/badge.svg?branch=main)](https://github.com/kunduso/terraform-aws-vpc/actions/workflows/code-scan.yml) [![Generate terraform docs](https://github.com/kunduso/terraform-aws-vpc/actions/workflows/documentation.yml/badge.svg?branch=main)](https://github.com/kunduso/terraform-aws-vpc/actions/workflows/documentation.yml)
# Terraform Module for Amazon Virtual Private Cloud resources
This repository contains a Terraform module that automates the creation of Amazon Virtual Private Cloud (VPC) resources on AWS.

## Overview
This module provides a complete foundation for setting up secure, isolated environments in AWS, including:
- Automated VPC creation with customizable CIDR blocks
- Public and private subnet configuration
- Network traffic logging and monitoring capabilities
- Built-in security best practices
- Configurable NAT gateways for private subnet access

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

No modules.

## Resources

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
| [random_string.vpc_name](https://registry.terraform.io/providers/hashicorp/random/3.6.3/docs/resources/string) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vpc_flow_log_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Enable DNS hostnames for VPC. | `bool` | `false` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable DNS support for VPC. | `bool` | `false` | no |
| <a name="input_enable_flow_log"></a> [enable\_flow\_log](#input\_enable\_flow\_log) | Enable VPC flow logs | `bool` | `true` | no |
| <a name="input_enable_internet_gateway"></a> [enable\_internet\_gateway](#input\_enable\_internet\_gateway) | Enable internet gateway for VPC. | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Enable nat gateway for VPC. | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to provision resources. | `string` | n/a | yes |
| <a name="input_subnet_cidr_private"></a> [subnet\_cidr\_private](#input\_subnet\_cidr\_private) | CIDR blocks for the private subnets. | `list(any)` | <pre>[<br/>  "10.20.30.0/27",<br/>  "10.20.30.32/27",<br/>  "10.20.30.64/27",<br/>  "10.20.30.96/27"<br/>]</pre> | no |
| <a name="input_subnet_cidr_public"></a> [subnet\_cidr\_public](#input\_subnet\_cidr\_public) | CIDR blocks for the public subnets. | `list(any)` | <pre>[<br/>  "10.20.30.128/27",<br/>  "10.20.30.160/27",<br/>  "10.20.30.192/27",<br/>  "10.20.30.224/27"<br/>]</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR for the VPC. | `string` | `"10.20.30.0/24"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_cloudwatch_log_group"></a> [aws\_cloudwatch\_log\_group](#output\_aws\_cloudwatch\_log\_group) | The CloudWatch Log Group (if enabled). |
| <a name="output_aws_iam_role"></a> [aws\_iam\_role](#output\_aws\_iam\_role) | The IAM Role (if enabled). |
| <a name="output_flow_log"></a> [flow\_log](#output\_flow\_log) | The flow log (if enabled). |
| <a name="output_iam_policy"></a> [iam\_policy](#output\_iam\_policy) | The IAM Policy (if enabled). |
| <a name="output_internet_gateway"></a> [internet\_gateway](#output\_internet\_gateway) | The Internet Gateway (if enabled). |
| <a name="output_internet_route"></a> [internet\_route](#output\_internet\_route) | The Internet Gateway route (if enabled). |
| <a name="output_kms_key"></a> [kms\_key](#output\_kms\_key) | The KMS Key to encrypt the AWS CloudWatch Logs (if enabled). |
| <a name="output_kms_key_alias"></a> [kms\_key\_alias](#output\_kms\_key\_alias) | The alias of the KMS key (if enabled). |
| <a name="output_kms_key_policy"></a> [kms\_key\_policy](#output\_kms\_key\_policy) | The IAM policy for the KMS key (if enabled). |
| <a name="output_nat_gateway"></a> [nat\_gateway](#output\_nat\_gateway) | The NAT Gateway (if enabled). |
| <a name="output_nat_gateway_public_ips"></a> [nat\_gateway\_public\_ips](#output\_nat\_gateway\_public\_ips) | List of public Elastic IPs created for NAT Gateway (if enabled). |
| <a name="output_private_route"></a> [private\_route](#output\_private\_route) | The private route. |
| <a name="output_private_route_table"></a> [private\_route\_table](#output\_private\_route\_table) | The priavte route tables created in this module. |
| <a name="output_private_route_table_association"></a> [private\_route\_table\_association](#output\_private\_route\_table\_association) | The private route table association. |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of private subnets. |
| <a name="output_public_route_table"></a> [public\_route\_table](#output\_public\_route\_table) | The public route table. |
| <a name="output_public_route_table_association"></a> [public\_route\_table\_association](#output\_public\_route\_table\_association) | The public route table association. |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of public subnets. |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | The VPC created via this module. |
<!-- END_TF_DOCS -->

## Usage
To use this module in your Terraform configuration, include the following module block:

```hcl
module "vpc" {
  source = "github.com/kunduso/terraform-aws-vpc"
  region = var.region
}
````
## Example Implementation
A complete example implementation of this module can be found in the [example directory](./example/). The example demonstrates how to:

- Set up the AWS provider
- Configure the VPC module
- Define required variables
- Set up backend configuration

You can use this example as a reference for implementing the module in your own infrastructure code.
</br> Additionally, the repository includes [Azure Pipelines](./pipeline/azure-pipelines.yaml) to automate the deployment of this infrastructure as part of a CI/CD pipeline. This makes it easy to apply your Terraform configurations directly from the pipeline.
</br> Details available at [Exploring Azure Pipelines, Terraform, and Powershell](https://skundunotes.com/2021/02/25/exploring-azure-pipelines-terraform-and-powershell/)

Note: Ensure you have appropriate AWS credentials configured before running the example.

## Contributing
If you find any issues or have suggestions for improvement, feel free to open an issue or submit a pull request. Contributions are always welcome!
## License
This code is released under the Unlicense License. See [LICENSE](LICENSE).