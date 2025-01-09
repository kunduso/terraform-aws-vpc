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