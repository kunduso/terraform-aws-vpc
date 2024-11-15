variable "region" {
  description = "The AWS region to provision resources."
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR for the VPC."
  default     = "10.20.30.0/24"
}
variable "subnet_cidr_private" {
  description = "CIDR blocks for the private subnets."
  default     = ["10.20.30.0/27", "10.20.30.32/27", "10.20.30.64/27", "10.20.30.96/27"]
  type        = list(any)
}
variable "subnet_cidr_public" {
  description = "CIDR blocks for the public subnets."
  default     = ["10.20.30.128/27", "10.20.30.160/27", "10.20.30.192/27", "10.20.30.224/27"]
  type        = list(any)
}
variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames for VPC."
  type        = bool
  default     = false
}
variable "enable_dns_support" {
  description = "Enable DNS support for VPC."
  type        = bool
  default     = false
}
variable "vpc_name" {
  description = "Name of the VPC."
  default     = ""
}
variable "enable_internet_gateway" {
  description = "Enable internet gateway for VPC."
  type        = bool
  default     = false
}
variable "enable_nat_gateway" {
  description = "Enable nat gateway for VPC."
  type        = bool
  default     = false
}
variable "enable_flow_log" {
  description = "Enable VPC flow logs"
  type        = bool
  default     = true
}