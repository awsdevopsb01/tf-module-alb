resource "aws_security_group" "main" {
  name        = "${var.name}-alb-${var.env}-sg"
  description = "${var.name}-alb-${var.env}-sg"
  vpc_id      = var.vpc_id

  ingress {
    description      = "alb_http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.allow_alb_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, {Name="${var.env}-${var.name}-alb-sg" })
}

resource "aws_lb" "alb" {
  name               = "${var.name}-alb-${var.env}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = var.subnets


  tags = merge(var.tags, { Name = "${var.env}-${var.name}-alb" })
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}