# enabling dns lookup, hostname and vpc tagging
resource "null_resource" "update-vpc" {
  provisioner "local-exec" {
    command = "${local.modify-vpc-attr1} ; ${local.modify-vpc-attr2} ; ${local.add-vpc-tag} ; ${local.desc-vpc-attr1} >> ${local.logfile}; ${local.desc-vpc-attr2} >> ${local.logfile} ; ${local.desc-vpc-tag} >> ${local.logfile}"
  }
}

# private subnets
resource "aws_subnet" "private" {
  count             = length(local.azs)
  availability_zone = "${local.azs[count.index]}"
  cidr_block        = "${var.vpc_pri_suffix}${count.index}.0/24"
  vpc_id            = local.vpc_id
  tags = "${
    map(
      "Name", "${local.vpc-name}-private",
      "kubernetes.io/cluster/${local.cluster-name}", "shared",
      "kubernetes.io/role/internal-elb", "1",
    )
  }"
  depends_on = ["null_resource.update-vpc"]
}

# public subnets
resource "aws_subnet" "public" {
  count             = length(local.azs)
  availability_zone = "${local.azs[count.index]}"
  cidr_block        = "${var.vpc_pub_suffix}${count.index}.0/24"
  vpc_id            = local.vpc_id
  tags = "${
    map(
      "Name", "${local.vpc-name}-public",
      "kubernetes.io/cluster/${local.cluster-name}", "shared",
      "kubernetes.io/role/elb", "1",
    )
  }"
  depends_on = ["null_resource.update-vpc"]
}

# Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = local.vpc_id
  tags = {
    Name = "${local.vpc-name}-igw"
  }
}

# EIP for public subnets
resource "aws_eip" "nat" {
  count = length(aws_subnet.public.*.id)
  vpc   = true

  tags = "${
    map(
      "Name", "${local.vpc-name}-eip",
      "kubernetes.io/cluster/${local.cluster-name}", "shared",
    )
  }"
}

# NAT Gateway
resource "aws_nat_gateway" "this" {
  count = length(aws_subnet.public.*.id)
  #count = length(data.aws_availability_zones.az.names)

  allocation_id = element(
    aws_eip.nat.*.id,
    count.index,
  )
  subnet_id = element(
    aws_subnet.public.*.id,
    count.index,
  )
  tags = "${
    map(
      "Name", "${local.vpc-name}-natgw",
      "kubernetes.io/cluster/${local.cluster-name}", "shared",
    )
  }"

  depends_on = [aws_internet_gateway.gw]
}

# Publiс routes
################
resource "aws_route_table" "public" {
  vpc_id = local.vpc_id

  tags = "${
    map(
      "Name", "${local.vpc-name}-public-rt",
      "kubernetes.io/cluster/${local.cluster-name}", "shared",
    )
  }"

}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id

  timeouts {
    create = "5m"
  }
}

# Private routes
#################
resource "aws_route_table" "private" {
  count  = length(aws_subnet.private.*.id)
  vpc_id = local.vpc_id

  tags = "${
    map(
      "Name", "${local.vpc-name}-private-rt",
      "kubernetes.io/cluster/${local.cluster-name}", "shared",
    )
  }"
}

# Private routing tables
############################
resource "aws_route" "private_nat_gateway" {
  count = length(aws_subnet.private.*.id)

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this.*.id, count.index)

  timeouts {
    create = "5m"
  }
}

# Route table association
##########################
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private.*.id)
  #count = length(var.private_subnets)

  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(
    aws_route_table.private.*.id,
    count.index,
  )
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public.*.id)
  #count = length(var.public_subnets)

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}


# NAT Gateways for private subnets
#resource "aws_route_table" "dev" {
#  vpc_id = "${var.vpc-id}"
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = "${aws_internet_gateway.gw.id}"
#  }
#}
#resource "aws_route_table_association" "dev" {
#  count = 3
#  subnet_id      = "${aws_subnet.dev.*.id[count.index]}"
#  route_table_id = "${aws_route_table.dev.id}"
#}
