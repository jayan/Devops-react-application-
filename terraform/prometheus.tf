# Define provider
provider "aws" {
  region = "ap-south-1"
}

# Create key pair resource
resource "aws_key_pair" "webserver" {
  key_name   = "webserver" # Name of the existing key pair
}

# Create security group resource
resource "aws_security_group" "prometheus_sg" {
  name        = "prometheus_sg"
  description = "Security group for Prometheus instance"

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow port 3000
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow port 9090
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic is allowed by default
}

# Launch EC2 instance
resource "aws_instance" "prometheus_instance" {
  ami             = "ami-0f58b397bc5c1f2e8" # Ubuntu 20.04 LTS AMI (replace with your desired Ubuntu AMI)
  instance_type   = "t2.micro" # Instance type can be adjusted as needed
  key_name        = aws_key_pair.webserver.key_name
  security_groups = [aws_security_group.prometheus_sg.name]

  tags = {
    Name = "prometheus"
  }
}
