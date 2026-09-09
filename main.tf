provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket         = "seniyan-terraform-state-bucket"
    key            = "ec2/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
  }
}

# Manage the default security group in the default VPC
resource "aws_default_security_group" "default" {
  vpc_id = data.aws_vpc.default.id

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # replace with your IP for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Data source to fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "LinuxMachine" {
  ami           = "ami-090d68841c2a28756"        # replace with valid AMI
  instance_type = "t3.micro"
  key_name      = "sshkey-si"     # already created in AWS

  tags = {
    Name        = "LinuxMachine"
    Environment = "Dev"
    Owner       = "Silambu"
  }
}
