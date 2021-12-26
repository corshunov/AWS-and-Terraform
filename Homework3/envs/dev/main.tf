module "vpc" {
  source                    = "./../../modules/vpc"
  vpc_cidr                  = var.vpc_cidr
  public_cidrs              = var.vpc_public_cidrs
  private_cidrs             = var.vpc_private_cidrs
}

module "db_servers" {
  source                    = "./../../modules/db_servers"
  vpc_id                    = module.vpc.vpc_id
  ami_id                    = data.aws_ami.ubuntu_18.id
  key_name                  = var.db_key_name
  instance_type             = var.db_instance_type
  instance_count            = var.db_instance_count
  subnet_ids                = module.vpc.private_subnets
}

module "web_servers" {
  source                    = "./../../modules/web_servers"
  vpc_id                    = module.vpc.vpc_id
  ami_id                    = data.aws_ami.ubuntu_18.id
  key_name                  = var.web_key_name
  instance_type             = var.web_instance_type
  instance_count            = var.web_instance_count
  subnet_ids                = module.vpc.public_subnets
  disk_volume_type          = var.web_disk_volume_type
  root_disk_size            = var.web_root_disk_size
  second_disk_size          = var.web_second_disk_size 
  second_disk_device_name   = var.web_second_disk_device_name
}
