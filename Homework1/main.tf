# PROVIDERS
provider "aws" {
  region = "us-east-1"
}

# DATA
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical account ID
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

data "template_file" "user_data" {
  template = file("./scripts/run_nginx.yaml")
}

# RESOURCES
resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_a" {
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "whiskey_sg" {
  name        = "whiskey_sg"
  description = "Security group for whiskey website"
  vpc_id      = aws_default_vpc.default.id

  # SSH
  #ingress {
  #  from_port   = 22
  #  to_port     = 22
  #  protocol    = "tcp"
  #  cidr_blocks = ["0.0.0.0/0"]
  #}

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  count                       = 2
  subnet_id                   = aws_default_subnet.default_a.id
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [aws_security_group.whiskey_sg.id]
  user_data                   = data.template_file.user_data.rendered
 
  # Inserting AWS key for SSH
  #key_name                    = "terra"

  ebs_block_device {
    device_name = "/dev/sdf"
    encrypted   = "true"
    volume_size = 10 # GB
    volume_type = "gp2"
  }
  
  tags = {
    Name    = "nginx_server_${count.index+1}"
    Owner   = "Grandpa"
    Purpose = "Server for whiskey website"
  }
}

# OUTPUT
output "aws_instance_public_ips" {
  value = [aws_instance.nginx.*.public_ip]
}
