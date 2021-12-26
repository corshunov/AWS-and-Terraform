resource "aws_instance" "web" {
  count                       = var.instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_ids[count.index]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web.id]
  user_data                   = local.user_data

  root_block_device {
    encrypted   = false
    volume_type = var.disk_volume_type
    volume_size = var.root_disk_size
  }

  ebs_block_device {
    encrypted   = true
    volume_type = var.disk_volume_type
    volume_size = var.second_disk_size
    device_name = var.second_disk_device_name
  }

  tags = {
    Name    = "web_server_${count.index+1}"
  }
}

resource "aws_security_group" "web" {
  name        = "web"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "web_http_ingress" {
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "web_ssh_ingress" {
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "web_all_egress" {
  type        = "egress"
  protocol    = "-1"
  from_port   = 0
  to_port     = 0
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id
}
