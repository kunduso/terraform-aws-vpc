[![Build Status](https://littlecoding.visualstudio.com/Open-Project/_apis/build/status/kunduso.AzureDevOps-Terraform-AWS-VPC-Integration?branchName=main)](https://littlecoding.visualstudio.com/Open-Project/_build/latest?definitionId=18&branchName=main)
# Terraform Module for Amazon Virtual Private Cloud resources
This repository contains a Terraform module that automates the creation of Amazon Virtual Private Cloud (VPC) resources on AWS. The module provisions essential VPC components, including:
<br /> **- VPC:** The Virtual Private Cloud itself.
<br /> **- Public and private subnets:** For organizing resources into public and private network segments.
<br />**- Route tables:** For managing routing between subnets and to the internet.
<br />**- Internet Gateway (optional):** Provides internet access to public subnets.
<br />**- NAT Gateway (optional):** Allows private subnets to access the internet.
<br />**- Elastic IP (optional for NAT Gateway):** Automatically allocated for the NAT Gateway when enabled.
<br />**- VPC Flow Logs:** Automatically enables flow logs to capture information about the IP traffic going to and from network interfaces in the VPC. These logs are useful for security analysis, monitoring, and troubleshooting.

This module provides a complete foundation for setting up secure, isolated environments in AWS, including the ability to track and log network traffic for auditing and security purposes.

The repository also includes example configurations that demonstrate how to use the module in various environments, including common VPC setups for development, staging, and production.

Additionally, the repository includes [Azure Pipelines](./pipeline/azure-pipelines.yaml) to automate the deployment of this infrastructure as part of a CI/CD pipeline. This makes it easy to apply your Terraform configurations directly from the pipeline.


</br> Details available at [Exploring Azure Pipelines, Terraform, and Powershell](https://skundunotes.com/2021/02/25/exploring-azure-pipelines-terraform-and-powershell/)



Here are the sections that should be included in the `README.md` file for the Terraform VPC module repository:

1. **Project Overview**
2. **Prerequisites**
3. **Getting Started**
4. **Module Input Variables**
5. **Module Outputs**
6. **Usage**
7. **Example**
8. **Dependencies**
9. **Versioning**
10. **License**
11. **Contributing**
12. **Support and Contact**
