provider "aws" {
  region = "ap-south-1"
}

# Create a security group allowing inbound SSH access from your IP address only
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Security group for Jenkins instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.44.15.122/32"]  # Restrict SSH to your IP address
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow inbound access on port 80 from anyone
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launching EC2 instance named "jenkins" with Ubuntu image, t2.micro instance type, and your specified key pair
resource "aws_instance" "jenkins_instance" {
  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t2.micro"
  key_name      = "webserver"  # Specify your existing key pair name here

  tags = {
    Name = "jenkins"
  }

  security_groups = [aws_security_group.jenkins_sg.name]
}
