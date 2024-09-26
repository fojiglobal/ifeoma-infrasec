# Test Resource

resource "aws_instance" "test1" {
  ami = "ami-085f9c64a9b75eed5"
  instance_type = "t2.micro"
  tags = {
    Name = "test1"
  }
}