variable "region" {
  description = "The AWS region to provision resources."
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR for the VPC."
  default     = ""
}
variable "subnet_cidr_private" {
  description = "CIDR blocks for the private subnets."
  default     = []
  type        = list(any)
}
variable "subnet_cidr_public" {
  description = "CIDR blocks for the public subnets."
  default     = []
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