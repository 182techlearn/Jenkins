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
    to_port     = 8089
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
resource "aws_instance" "LinuxMachine1" {
  ami           = "ami-090d68841c2a28756"        # replace with valid AMI
  instance_type = "t3.micro"
  key_name      = "sshkey-si"     # already created in AWS

  tags = {
    Name        = "webserver_Tomcat"
    Environment = "Dev"
    Owner       = "Silambu"
  }
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "LinuxMachine3" {
  ami           = "ami-022374b883d9d7931"
  instance_type = "t3.micro"
  key_name      = "sshkey-si"

  tags = {
    Name        = "Ansible_server"
    Environment = "Dev"
    Owner       = "Silambu"
  }
}

resource "aws_instance" "eksbootstrap" {
  ami           = "ami-022374b883d9d7931"
  instance_type = "t3.micro"
  key_name      = "sshkey-si"
  iam_instance_profile = aws_iam_instance_profile.eks_admin_profile.name


  tags = {
    Name        = "eks_bootstrap_server"
    Environment = "Dev"
    Owner       = "Silambu"
  }
}





/*
data "aws_ami" "windows_2022" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }
}
resource "aws_instance" "windows_server" {
  ami           = data.aws_ami.windows_2022.id
  instance_type = "t3.micro" 
  key_name      = "sshkey-si"

  # Allocate exactly 30GB to maximize the free tier storage tier
  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
  }

  # Required to grab the generated Windows password later
  get_password_data = true

  tags = {
    Name        = "WindowsServer_wserver"
    Environment = "Dev"
  }
}*/
