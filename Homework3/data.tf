data "aws_availability_zones" "available" {}

data "aws_ami" "ubuntu_18" {
  most_recent = true
  owners      = [var.ubuntu_account_number]
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}