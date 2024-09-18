###################### Launch Template ######################

resource "aws_launch_template" "staging_lt" {
  name = "${var.env}-lt"

  image_id = "ami-085f9c64a9b75eed5"

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.micro"

  key_name = "cs2-us-east-2-main"

  vpc_security_group_ids = [ aws_security_group.prv_sg.id ]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.env}-asg-web-server"
    }
  }

  user_data = filebase64("web.sh")
}

###################### ASG ######################

resource "aws_autoscaling_group" "staging_asg" {
  name = "${var.env}-asg"
  vpc_zone_identifier = [ aws_subnet.staging_prv_1.id, aws_subnet.staging_prv_2.id]
  desired_capacity = 2
  max_size = 3
  min_size = 1

  launch_template {
    id = aws_launch_template.staging_lt.id
    version = "$Latest"
  }

  tag {
    key = "name"
    value = "${var.env}-asg-web-server"
    propagate_at_launch = true
  }
}