resource "aws_instance" "web_servers" {
  count                  = length(["10.0.1.0/24", "10.0.2.0/24"])
  ami                    = data.aws_ami.debian.id
  instance_type          = "t3.micro"
  subnet_id              = module.network.public_subnets_id[count.index]
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  tags = merge(var.tags, { Name = "${var.tags.Project}-instance-${count.index}" })
}