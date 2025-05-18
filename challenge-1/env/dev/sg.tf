resource "aws_security_group" "public_sg" {
  name        = "SG-ssh"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = module.network.vpc_id

  tags = merge(var.tags, { Name = "SG-ssh" })
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = module.network.vpc_cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}