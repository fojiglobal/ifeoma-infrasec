###################### Target Group ######################

resource "aws_lb_target_group" "staging_tg" {
  name     = "${var.env}-tg-80"
  port     = var.http_port
  protocol = var.http_protocol
  vpc_id   = aws_vpc.staging.id

  health_check {
    healthy_threshold = 2
    interval          = 10
  }
}

###################### Application Load Balancer ######################

resource "aws_lb" "staging_alb" {
  name               = "${var.env}-alb"
  subnets            = [aws_subnet.staging_pub_1.id, aws_subnet.staging_pub_2.id]
  internal           = false
  security_groups    = [aws_security_group.pub_sg.id]
  load_balancer_type = "application"
  drop_invalid_header_fields = true
  
  tags = {
    Name        = "${var.env}-alb"
    Environment = var.env
  }
}

###################### Listeners ######################

resource "aws_lb_listener" "staging_https" {
  load_balancer_arn = aws_lb.staging_alb.arn
  port              = var.https_port
  protocol          = var.https_protocol
  ssl_policy        = var.alb_ssl_profile
  certificate_arn   = data.aws_acm_certificate.alb_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.staging_tg.arn
  }
}

resource "aws_lb_listener" "http_to_https" {
  load_balancer_arn = aws_lb.staging_alb.arn
  port              = var.http_port
  protocol          = var.http_protocol

  default_action {
    type = "redirect"

    redirect {
      port        = var.https_port
      protocol    = var.https_protocol
      status_code = "HTTP_301"
    }
  }
}

###################### Listener Rule ######################

resource "aws_lb_listener_rule" "staging_web_rule" {
  listener_arn = aws_lb_listener.staging_https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.staging_tg.arn
  }

  condition {
    host_header {
      values = ["www.stg.cloudwithify.online", "stg.cloudwithify.online"]
    }
  }
}