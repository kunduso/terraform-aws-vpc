variable "region" {
  description = "The AWS region to provision resources."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "Region must be a valid AWS region name (e.g., us-east-1, eu-west-1)."
  }
}
variable "tags" {
  description = "AWS Cloud resource tags."
  type        = map(string)
  default = {
    "Module" = "https://github.com/kunduso/terraform-aws-vpc"
  }

  validation {
    condition     = length(var.tags) > 0
    error_message = "At least one tag must be specified."
  }
}
variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid IPv4 CIDR block."
  }

  validation {
    condition     = tonumber(split("/", var.vpc_cidr)[1]) >= 16 && tonumber(split("/", var.vpc_cidr)[1]) <= 28
    error_message = "VPC CIDR block must be between /16 and /28."
  }
}

variable "subnet_cidr_private" {
  description = "CIDR blocks for the private subnets."
  default     = []
  type        = list(any)

  validation {
    condition = alltrue([
      for cidr in var.subnet_cidr_private : can(cidrhost(cidr, 0))
    ])
    error_message = "All private subnet CIDR blocks must be valid IPv4 CIDR notation."
  }
}
variable "subnet_cidr_public" {
  description = "CIDR blocks for the public subnets."
  default     = []
  type        = list(any)

  validation {
    condition = alltrue([
      for cidr in var.subnet_cidr_public : can(cidrhost(cidr, 0))
    ])
    error_message = "All public subnet CIDR blocks must be valid IPv4 CIDR notation."
  }
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

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]*$", var.vpc_name))
    error_message = "VPC name can only contain alphanumeric characters, hyphens, and underscores."
  }

  validation {
    condition     = length(var.vpc_name) <= 255
    error_message = "VPC name cannot be longer than 255 characters."
  }
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

  validation {
    condition     = !var.enable_nat_gateway || var.enable_internet_gateway
    error_message = "NAT Gateway requires Internet Gateway to be enabled. Please set enable_internet_gateway to true when enable_nat_gateway is true."
  }
}
variable "enable_flow_log" {
  description = "Enable VPC flow logs"
  type        = bool
  default     = true
}

variable "public_subnet_tags" {
  description = "Additional tags for public subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags for private subnets"
  type        = map(string)
  default     = {}
}