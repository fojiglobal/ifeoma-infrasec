###################### Data Sources ######################
data "aws_route53_zone" "my_domain" {
  name = "${var.my_domain_name}."
}

data "aws_acm_certificate" "alb_cert" {
  domain      = "*.${var.my_domain_name}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

###################### VPC ######################

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "${var.env}-vpc"
    Environment = var.env
  }
}

###################### Public Subnets ######################

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value["cidr"]
  availability_zone       = each.value["azs"]
  tags                    = each.value["tags"]
  map_public_ip_on_launch = var.map_public_ip
}

###################### Private Subnets ######################

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["azs"]
  tags              = each.value["tags"]
}

###################### Internet Gateway ######################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.env}-igw"
  }
}

###################### NAT Gateway ######################

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public[var.pub_sub_name].id
  depends_on    = [aws_internet_gateway.this]

  tags = {
    Name = "${var.env}-ngw"
  }
}

###################### Elastic IP for the NAT Gateway ######################

resource "aws_eip" "this" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.this]

  tags = {
    Name = "${var.env}-eip"
  }
}

###################### Route Tables ######################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = var.all_ipv4_cidr
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name        = "${var.env}-public-rt"
    Environment = var.env
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = var.all_ipv4_cidr
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name        = "${var.env}-private-rt"
    Environment = var.env
  }
}

##### Subnet Association to Route Tables #####

resource "aws_route_table_association" "public" {
  for_each = var.public_subnets

  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnets

  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[each.key].id
}

###################### Launch Template ######################

resource "aws_launch_template" "lt" {
  name                                 = "${var.env}-lt"
  image_id                             = var.ami_id
  instance_type                        = var.instance_type
  key_name                             = var.key_pair
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids               = [aws_security_group.private.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.env}-asg-web-server"
    }
  }

  user_data = var.user_data
}

###################### ASG ######################

resource "aws_autoscaling_group" "asg" {
  name                = "${var.env}-asg"
  vpc_zone_identifier = [for subnet in aws_subnet.private : subnet.id]
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  #   target_group_arns = []

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  tag {
    key                 = "name"
    value               = "${var.env}-asg-web-server"
    propagate_at_launch = true
  }
}

###################### Target Group ######################

resource "aws_lb_target_group" "tg" {
  name     = "${var.env}-tg-80"
  port     = var.http_port
  protocol = var.http_protocol
  vpc_id   = aws_vpc.this.id

  health_check {
    healthy_threshold = 2
    interval          = 10
  }
}

###################### Load Balancer ######################

resource "aws_lb" "alb" {
  name               = "${var.env}-alb"
  internal           = var.internet_facing
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.public.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  tags = {
    Name        = "${var.env}-alb"
    Environment = var.env
  }
}

###################### Listeners ######################

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.https_port
  protocol          = var.https_protocol
  ssl_policy        = var.alb_ssl_profile
  certificate_arn   = data.aws_acm_certificate.alb_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_listener" "http_to_https_listener" {
  load_balancer_arn = aws_lb.alb.arn
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

###################### Listener Rules ######################

resource "aws_lb_listener_rule" "web_rule" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition {
    host_header {
      values = ["www.${var.my_domain_env}.${var.my_domain_name}", "${var.my_domain_env}.${var.my_domain_name}"]
    }
  }
}