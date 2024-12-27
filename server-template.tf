terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

provider "aws" {
  region     = #<enter avzone>
  access_key = #<enter access key>
  secret_key = #<enter secret key>
}

#create VPC
resource "aws_vpc" "practice-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "practice-vpc"
  }
}

#create internet Gateway
resource "aws_internet_gateway" "practice-igw" {
  vpc_id = aws_vpc.practice-vpc.id

  tags = {
    Name = "practice-igw"
  }
}

#create custom route table
resource "aws_route_table" "practice-rtb" {
  vpc_id = aws_vpc.practice-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.practice-igw.id
  }

  tags = {
    Name = "practice-rtb"
  }
}

#create subnet
resource "aws_subnet" "practice-subnet" {
  vpc_id            = aws_vpc.practice-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = #<enter avzone>

  tags = {
    Name = "practice-subnet"
  }
}

#associate subnet with route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.practice-subnet.id
  route_table_id = aws_route_table.practice-rtb.id
}

#create security group
resource "aws_security_group" "allow_webtraffics" {
  name        = "allow_webtraffics"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.practice-vpc.id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_webtraffics"
  }
}

#create server
resource "aws_instance" "practice-webserver" {
  ami                         = #<enter AMI>
  instance_type               = #<enter instance type>
  availability_zone           = #<enter avzome>
  key_name                    = #<enter keyname>
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.practice-subnet.id
  vpc_security_group_ids      = [aws_security_group.allow_webtraffics.id]

  # Bootstrap script to install and start a web server
  user_data = <<-EOF
  #!/bin/bash
  #insert user data
  EOF

  tags = {
    Name = "practice-webserver"
  }
}

# Output the public IP of the instance
output "instance_public_ip" {
  value = aws_instance.practice-webserver.public_ip
}
