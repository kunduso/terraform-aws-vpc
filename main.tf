locals {
  vpc_name = var.vpc_name == "" ? "vpc-${random_string.vpc_name[0].result}" : var.vpc_name
}
# https://docs.aws.amazon.com/glue/latest/dg/set-up-vpc-dns.html
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#enable_dns_support
  enable_dns_support = var.enable_dns_support == null ? false : var.enable_dns_support
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#enable_dns_hostnames
  enable_dns_hostnames = var.enable_dns_hostnames == null ? false : var.enable_dns_hostnames
  tags                 = merge({ "Name" = local.vpc_name }, var.tags)
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones
data "aws_availability_zones" "available" {
  state = "available"
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "private" {
  count             = length(var.subnet_cidr_private)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.subnet_cidr_private[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index % 3]
  tags              = merge({ "Name" = "${local.vpc_name}-private-${count.index + 1}" }, var.tags)
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "public" {
  count                   = length(var.subnet_cidr_public)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.subnet_cidr_public[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index % 3]
  map_public_ip_on_launch = true
  tags                    = merge({ "Name" = "${local.vpc_name}-public-${count.index + 1}" }, var.tags)
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "private" {
  count  = length(var.subnet_cidr_private) > 0 ? length(var.subnet_cidr_private) : 0
  vpc_id = aws_vpc.this.id
  tags   = merge({ "Name" = "${local.vpc_name}-private-${count.index + 1}" }, var.tags)
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "public" {
  count  = length(var.subnet_cidr_public) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags   = merge({ "Name" = "${local.vpc_name}-public" }, var.tags)
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "private" {
  count          = length(var.subnet_cidr_private) > 0 ? length(var.subnet_cidr_private) : 0
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private[count.index].id
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "public" {
  count          = length(var.subnet_cidr_public) > 0 ? length(var.subnet_cidr_public) : 0
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "this_igw" {
  count  = var.enable_internet_gateway && length(var.subnet_cidr_public) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags   = merge({ "Name" = "${local.vpc_name}-gateway" }, var.tags)
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
resource "aws_route" "internet_route" {
  count                  = var.enable_internet_gateway && length(var.subnet_cidr_public) > 0 ? 1 : 0
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public[0].id
  gateway_id             = aws_internet_gateway.this_igw[0].id
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "nat_gateway" {
  count  = (var.enable_nat_gateway && var.enable_internet_gateway && length(var.subnet_cidr_public) > 0) && (length(var.subnet_cidr_private) == length(var.subnet_cidr_public)) ? length(var.subnet_cidr_public) : 0
  domain = "vpc"
  #checkov:skip=CKV2_AWS_19: The IP is attached to the NAT gateway
  tags = merge({ "Name" = "${local.vpc_name}-nat-eip-${count.index + 1}" }, var.tags)
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "public" {
  count         = (var.enable_nat_gateway && var.enable_internet_gateway && length(var.subnet_cidr_public) > 0) && (length(var.subnet_cidr_private) == length(var.subnet_cidr_public)) ? length(var.subnet_cidr_public) : 0
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = aws_eip.nat_gateway[count.index].id
  depends_on    = [aws_internet_gateway.this_igw]
  tags          = merge({ "Name" = "${local.vpc_name}-nat-${count.index + 1}" }, var.tags)
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
resource "aws_route" "private_route" {
  count                  = (var.enable_nat_gateway && var.enable_internet_gateway && (length(var.subnet_cidr_private) == length(var.subnet_cidr_public)) && length(var.subnet_cidr_public) > 0) ? length(var.subnet_cidr_private) : 0
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private[count.index].id
  nat_gateway_id         = aws_nat_gateway.public[count.index].id
}