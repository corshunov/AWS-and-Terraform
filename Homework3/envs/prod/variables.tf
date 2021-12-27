### General ###
variable "env_tag" {
  type    = string
  default = "Production"
}

variable "owner_tag" {
  type    = string
  default = "Grandpa"
}

variable "purpose_tag" {
  type    = string
  default = "Whiskey"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

### VPC ###
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_public_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_private_cidrs" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

### WEB servers ###
variable "web_key_name" {
  type    = string
  default = "terra"
}

variable "web_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "web_instance_count" {
  type    = number
  default = 2
}

variable "web_disk_volume_type" {
  type    = string
  default = "gp2"
}

variable "web_root_disk_size" {
  type    = number
  default = 10
}

variable "web_second_disk_size" {
  type    = number
  default = 10
}

variable "web_second_disk_device_name" {
  type    = string
  default = "sdf"
}

variable "web_access_log_bucket_name" {
  type    = string
  default = "website-access-log-prod"
}

### DB servers ###
variable "db_key_name" {
  type    = string
  default = "terra"
}

variable "db_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "db_instance_count" {
  type    = number
  default = 2
}
