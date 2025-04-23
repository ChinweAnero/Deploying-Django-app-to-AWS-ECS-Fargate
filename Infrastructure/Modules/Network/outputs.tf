output "vpc_id" {
  value = aws_vpc.vpc.id
  description = "vpc id"
}

output "public_subnets" {
  value = [aws_subnet.public_subnet[0].id, aws_subnet.public_subnet[1].id]
}

output "private_subnet_frontend_" {
  value = [aws_subnet.private_subnet_frontend[0].id, aws_subnet.private_subnet_frontend[0].id]
}
output "private_subnet_backend_" {
  value = [aws_subnet.private_subnet_backend[0].id, aws_subnet.private_subnet_backend[0].id]
}