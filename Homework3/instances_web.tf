resource "aws_instance" "web" {
  count                       = var.number_web_instances
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.web_instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public.*.id[count.index]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg_web.id]
  user_data                   = local.web_user_data

  root_block_device {
    encrypted   = false
    volume_type = var.all_disks_volume_type
    volume_size = var.web_root_disk_size
  }

  ebs_block_device {
    encrypted   = true
    device_name = var.web_secondary_disk_device_name
    volume_type = var.all_disks_volume_type
    volume_size = var.web_secondary_disk_size
  }
  
  tags = {
    Name    = "web_server_${regex(".$", data.aws_availability_zones.available_azs.names[count.index])}"
  }
}

resource "aws_security_group" "web" {
  name        = "web"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "web_http_ingress" {
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_web.id
}

resource "aws_security_group_rule" "web_ssh_ingress" {
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_web.id
}

resource "aws_security_group_rule" "web_all_egress" {
  type        = "egress"
  protocol    = "-1"
  from_port   = 0
  to_port     = 0
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_web.id
}