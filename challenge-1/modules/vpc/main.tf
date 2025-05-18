# Création du VPC
resource "aws_vpc" "network" {
  cidr_block = var.vpc_cidr
  tags       = merge(var.tags, { Name = "${var.tags.Project}-${var.vpc_name}" })
}

# Création du IG
resource "aws_internet_gateway" "nw_endpoint" {
  vpc_id = aws_vpc.network.id
  tags   = merge(var.tags, { Name = "${var.tags.Project}-IG" })
}

# Création des subnetes publique
resource "aws_subnet" "public_subnets" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.network.id
  availability_zone = var.azs[count.index]
  cidr_block        = var.public_subnets[count.index]
  tags              = merge(var.tags, { Name = "${var.tags.Project}-public_subnets-${count.index}" })
}

# création du EIP pour la NG
resource "aws_eip" "ng_endpoint" {
  domain     = "vpc"
  tags       = merge(var.tags, { Name = "${var.tags.Project}-eip" })
  depends_on = [aws_vpc.network]
}

# Création du NG 
resource "aws_nat_gateway" "private_inetrnet_exit" {
  allocation_id = aws_eip.ng_endpoint.id
  # subnet id d'UN subnet publique, parce que la NG doit se trouver que dans un subnet publique!!
  # j'ai décidé de mettre mon NG dans le subnet publique dans l'az "eu-west-3a"
  subnet_id = aws_subnet.public_subnets[0].id

  tags = merge(var.tags, { Name = "${var.tags.Project}-NG" })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.nw_endpoint]
}

# Création du public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.network.id

  route {
    cidr_block = aws_vpc.network.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nw_endpoint.id
  }

  tags = merge(var.tags, { Name = "${var.tags.Project}-public_rt" })
}

# associer le public route table aux public subnet
resource "aws_route_table_association" "relation_rt_subnet_public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Création des subnets privé
resource "aws_subnet" "private_subnets" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.network.id
  availability_zone = var.azs[count.index]
  cidr_block        = var.private_subnets[count.index]
  tags              = merge(var.tags, { Name = "${var.tags.Project}-private_subnets-${count.index}" })
}

# Création du private route table 
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.network.id

  route {
    cidr_block = aws_vpc.network.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.private_inetrnet_exit.id
  }

  tags = merge(var.tags, { Name = "${var.tags.Project}-private_rt" })
}

# associer le private route table aux private subnet
resource "aws_route_table_association" "relation_rt_subnet_private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}