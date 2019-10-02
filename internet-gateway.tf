# Allowing the public subnets to be accessible from the internet,
# requires those subnets to be associated with a route table
# and that route table needs to be associated with an internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.stack_name}_igw"
  }
}
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${local.stack_name}"
  }
}

# Associate the subnets with the Route Table + Internet Gateway
resource "aws_route_table_association" "vpc-route-table-association" {
  route_table_id = aws_route_table.route_table.id
  count = length(local.public_subnets)

  subnet_id = aws_subnet.public_subnets.*.id[count.index]
}
