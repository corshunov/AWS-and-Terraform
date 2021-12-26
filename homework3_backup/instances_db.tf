resource "aws_instance" "db" {
  count                       = var.db_instance_count
  ami                         = data.aws_ami.ubuntu_18.id
  instance_type               = var.db_instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.private.*.id[count.index]
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.db.id]

  tags = {
    Name    = "db_server_${count.index+1}"
  }
}

resource "aws_security_group" "db" {
  name        = "db"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "db_ssh_ingress" {
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db.id
}

resource "aws_security_group_rule" "db_all_egress" {
  type        = "egress"
  protocol    = "-1"
  from_port   = 0
  to_port     = 0
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db.id
}
