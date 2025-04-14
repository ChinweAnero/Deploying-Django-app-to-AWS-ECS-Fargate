output "security_group_id" {
  value       = aws_security_group.sec_group.id
  description = "the id of the security group"
}

