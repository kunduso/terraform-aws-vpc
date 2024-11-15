[![Build Status](https://littlecoding.visualstudio.com/Open-Project/_apis/build/status%2Fkunduso.terraform-aws-vpc?branchName=main)](https://littlecoding.visualstudio.com/Open-Project/_build/latest?definitionId=37&branchName=main)
# Terraform Module for Amazon Virtual Private Cloud resources
This repository contains a Terraform module that automates the creation of Amazon Virtual Private Cloud (VPC) resources on AWS.

This module provides a complete foundation for setting up secure, isolated environments in AWS, including the ability to track and log network traffic for auditing and security purposes.

The repository also includes example configurations that demonstrate how to use the module in various environments, including common VPC setups for development, staging, and production.

Additionally, the repository includes [Azure Pipelines](./pipeline/azure-pipelines.yaml) to automate the deployment of this infrastructure as part of a CI/CD pipeline. This makes it easy to apply your Terraform configurations directly from the pipeline.
</br> Details available at [Exploring Azure Pipelines, Terraform, and Powershell](https://skundunotes.com/2021/02/25/exploring-azure-pipelines-terraform-and-powershell/)

<!-- BEGIN_TF_DOCS -->

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

Note: Ensure you have appropriate AWS credentials configured before running the example.

## Contributing
If you find any issues or have suggestions for improvement, feel free to open an issue or submit a pull request. Contributions are always welcome!
## License
This code is released under the Unlincse License. See [LICENSE](LICENSE).