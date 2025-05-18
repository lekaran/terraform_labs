output "public_subnets_id" {
  description = "The id list of the public subnets"
  value       = [for subnet in aws_subnet.public_subnets : subnet.id]
}

output "vpc_id" {
  description = "The vpc id"
  value       = aws_vpc.network.id
}

output "vpc_cidr_block" {
  description = "The CIDR of the vpc"
  value       = aws_vpc.network.cidr_block
}