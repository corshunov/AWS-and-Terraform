resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.web_instance_type
  count                       = var.number_web_instances
  subnet_id                   = element(aws_subnet.public_subnets.*.id, count.index)
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]
  user_data                   = local.web_instance_user_data
 
  # Inserting AWS key for SSH
  key_name                    = "terra"

  root_block_device {
    encrypted   = false
    volume_type = "gp2"
    volume_size = var.root_disk_size
  }

  ebs_block_device {
    device_name = "sdf"
    encrypted   = true
    volume_type = "gp2"
    volume_size = var.secondary_disk_size
  }
  
  tags = {
    Name    = "web_server_${count.index+1}"
    Purpose = "Web server for whiskey website"
  }
}

resource "aws_instance" "db" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.db_instance_type
  count                       = var.number_db_instances
  subnet_id                   = element(aws_subnet.private_subnets.*.id, count.index)
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.sg.id]
 
  # Inserting AWS key for SSH
  key_name                    = "terra"

  root_block_device {
    encrypted   = false
    volume_type = "gp2"
    volume_size = var.root_disk_size
  }

  ebs_block_device {
    device_name = "sdf"
    encrypted   = true
    volume_type = "gp2"
    volume_size = var.secondary_disk_size
  }
  
  tags = {
    Name    = "db_server_${count.index+1}"
    Purpose = "Database server for whiskey website"
  }
}

resource "aws_security_group" "sg" {
  name        = "whiskey_sg"
  description = "Security group for whiskey website"
  vpc_id      = aws_vpc.vpc.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

resource "aws_elb" "elb" {
  name                        = "whiskey-elb"
  subnets                     = aws_subnet.public_subnets.*.id
  instances                   = aws_instance.web.*.id
  security_groups             = [aws_security_group.sg.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 120
  connection_draining         = true
  connection_draining_timeout = 300

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 3
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
  }
}
