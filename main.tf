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
