
#**************configuring load balancer/listener and target groups******************#
resource "aws_lb" "load_B" {
  count = var.create_load_balancer == true ? 1 : 0
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sec_group]
  subnets            = [var.subnets[0], var.subnets[1]]
  enable_http2 = true
  idle_timeout = 30


  enable_deletion_protection = false

  tags = {
    Name = "Loadbalancer1"
  }
}

resource "aws_lb_listener" "https" {
  count = var.create_load_balancer == true ? (var.enable_https_listener == true ? 1 : 0) : 0
  load_balancer_arn = aws_lb.load_B[0].id
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }
  lifecycle {
    ignore_changes = [default_action]
  }
}

resource "aws_lb_listener" "http" {
  count = var.create_load_balancer == true ? 1 : 0
  load_balancer_arn = aws_lb.load_B[0].id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }
  lifecycle {
    ignore_changes = [default_action]
  }
}



resource "aws_lb_target_group" "ip_target_group" {
  count = var.create_target_group == true ? 1 : 0
  name        = var.name
  port        = var.port
  protocol    = var.protocol
  target_type = var.target_type
  vpc_id      = var.vpc_id
  deregistration_delay = 5

  health_check {
    enabled             = true
    interval            = 60
    path                = var.healthcheck_path
    port                = var.healthcheck_port
    protocol            = var.protocol
    timeout             = 30
    healthy_threshold   = 2
    unhealthy_threshold = 5
    matcher             = "200"
  }
  lifecycle {
    create_before_destroy = true
  }
}



