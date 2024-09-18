data "aws_route53_zone" "route53_cloudwithify" {
  name = "cloudwithify.online."
}

# data "aws_ami" "nginx_web_ami" {
#   most_recent = true
#   owners = [ "self" ]

#   filter {
#     name = "name"
#     values = [ "nginx-web-*" ]
#   }
# }

# output "my-nginx-ami" {
#   value = data.aws_ami.nginx_web_ami.id
# }