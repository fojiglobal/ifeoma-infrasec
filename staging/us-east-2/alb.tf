###################### Target Group ######################

resource "aws_lb_target_group" "staging_tg" {
  name = "${var.env}-tg-80"
  port = var.http_port
  protocol = var.http_protocol
  vpc_id = aws_vpc.staging.id

  health_check {
    healthy_threshold = 2
    interval = 10
  }
}

###################### Application Load Balancer ######################

resource "aws_lb" "staging_alb" {
  name = "${var.env}-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.pub_sg.id ]
  subnets = [ aws_subnet.staging_pub_1.id, aws_subnet.staging_pub_2.id ]

  tags = {
    Name = "${var.env}-alb"
    Environment = var.env
  }
}