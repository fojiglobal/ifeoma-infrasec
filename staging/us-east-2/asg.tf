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
      Name = "${var.env}-lt"
    }
  }

  user_data = filebase64("web.sh")
}