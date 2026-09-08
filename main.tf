provider "aws" {
  region = "us-east-1" # adjust to your region
}

resource "aws_instance" "Jenkins_lab" {
  ami           = "ami-081b0a6eac00b4f53" # Amazon Linux 2 AMI (update as needed)
  instance_type = "t3.micro"

  tags = {
    Name = "Linux-jenkins-EC2"
  }
}
