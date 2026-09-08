provider "aws" {
  region = "ap-south-1" # adjust to your region
}

resource "aws_instance" "Jenkins_lab" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI (update as needed)
  instance_type = "t2.micro"

  tags = {
    Name = "Linux-jenkins-EC2"
  }
}
