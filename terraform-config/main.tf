resource "aws_instance" "my_vm" {
  ami           = "ami-0d93d81bb4899d4cf" //Debian 11
  instance_type = "t2.micro"

  tags = {
    Name = "My EC2 instance",
  }
}