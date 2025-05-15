resource "aws_security_group_rule" "allow_traffic_at_port_80" {
  type              = var.type
  from_port         = var.from_port
  to_port           = var.to_port
  protocol          = var.protocol
  cidr_blocks       = var.cidr_blocks
  security_group_id = var.security_group_id
  description       = "Allow inbound HTTP at port 80"
}