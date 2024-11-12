variable "region" {
  description = "The AWS region to provision resources."
  type        = string
  default     = "us-east-1"
}
# variable "access_key" {
#   description = "The IAM access_key."
#   type        = string
#   sensitive   = true
# }
# variable "secret_key" {
#   description = "The IAM secret_key."
#   type        = string
#   sensitive   = true
# }
variable "vpc_cidr" {
  description = "CIDR for the VPC."
  default     = "10.20.30.0/24"
}
variable "subnet_cidr_private" {
  description = "CIDR blocks for the private subnets."
  default     = ["10.20.30.0/27", "10.20.30.32/27", "10.20.30.64/27"]
  type        = list(any)
}
variable "subnet_cidr_public" {
  description = "CIDR blocks for the public subnets."
  default     = ["10.20.30.96/27"]
  type        = list(any)
}
variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames for VPC."
  default     = false
}
variable "enable_dns_support" {
  description = "Enable DNS support for VPC."
  default     = false
}
variable "vpc_name" {
  description = "Name of the VPC."
  default     = ""
}