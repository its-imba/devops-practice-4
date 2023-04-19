# Create a keypair
resource "aws_key_pair" "mac-key" {
  key_name   = "mac-key-1"
  public_key = file("~/.ssh/id_rsa.pub") # Path to your public key
}

# Create a security group
resource "aws_security_group" "standard_access" {
  name_prefix = "jenky-flask-ssh"
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

# Outbound rule
egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
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

  user_data = <<-EOL
  #!/bin/bash -xe

  apt update
  apt install openjdk-8-jdk --yes
  wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
  echo "deb https://pkg.jenkins.io/debian binary/" >> /etc/apt/sources.list
  apt update
  apt install -y jenkins
  systemctl status jenkins
  find /usr/lib/jvm/java-1.8* | head -n 3  
  EOL

  tags = {
    Name = "My EC2 instance"

  }
}