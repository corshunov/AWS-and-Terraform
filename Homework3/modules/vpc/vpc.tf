resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public" {
  map_public_ip_on_launch = true
  count                   = length(var.public_cidrs)
  cidr_block              = var.public_cidrs[count.index]
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
}

resource "aws_subnet" "private" {
  map_public_ip_on_launch = false
  count                   = length(var.private_cidrs)
  cidr_block              = var.private_cidrs[count.index]
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
}

resource "aws_internet_gateway" "igw" {
  vpc_id     = aws_vpc.vpc.id
}

resource "aws_eip" "nat_eip" {
  count      = length(var.public_cidrs)
}

resource "aws_nat_gateway" "nat" {
  count             = length(var.public_cidrs)
  allocation_id     = aws_eip.nat_eip.*.id[count.index]
  subnet_id         = aws_subnet.public.*.id[count.index]
}

resource "aws_route_table" "route_tables" {
  count                   = length(var.route_tables)
  vpc_id                  = aws_vpc.vpc.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.route_tables[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_cidrs)
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.route_tables[0].id
}

resource "aws_route" "private" {
  count                  = length(var.private_cidrs)
  route_table_id         = aws_route_table.route_tables.*.id[count.index+1]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.*.id[count.index]
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_cidrs)
  subnet_id      = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.route_tables.*.id[count.index+1]
}
