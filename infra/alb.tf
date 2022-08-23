resource "aws_alb" "fargate-tutorial" {
  name               = "${var.service}-lb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_c.id,
  ]

  security_groups = [
    aws_security_group.http.id,
    aws_security_group.egress_all.id,
  ]

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_lb_target_group" "fargate-tutorial" {
  name        = var.service
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.fargate-tutorial.id

  health_check {
    enabled = true
    path    = "/health"
  }

  depends_on = [aws_alb.fargate-tutorial]
}

resource "aws_alb_listener" "fargate-tutorial_http" {
  load_balancer_arn = aws_alb.fargate-tutorial.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fargate-tutorial.arn
  }
}

# tell me URL to access the app
output "alb_url" {
  value = "http://${aws_alb.fargate-tutorial.dns_name}/"
}
