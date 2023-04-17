# Create a keypair
resource "aws_key_pair" "mac-key" {
  key_name   = "mac-key-1"
  public_key = file("~/.ssh/id_rsa.pub") # Path to your public key
}

# Create a security group
resource "aws_security_group" "standard_access" {
  name_prefix = "example-sg"
  description = "Allows ssh, jenkins, flask access"

  # Inbound rule to allow SSH access from any IP address
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbounce rule to allow Jenkins access from any IP
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbounce rule to allow Flask access from any IP
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a VM resource

resource "aws_instance" "my_vm" {
  ami           = "ami-0d93d81bb4899d4cf" // Debian 11
  instance_type = "t2.micro"

  # Associate the instance with the security group we created
  vpc_security_group_ids = [aws_security_group.standard_access.id]

  # Associate the instance with the keypair we created
  key_name = aws_key_pair.mac-key.id

  tags = {
    Name = "My EC2 instance"

  }
}