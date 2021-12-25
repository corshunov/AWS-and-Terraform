variable "owner_tag" {
  description = "The tag will be applied to every resource in the project"
  type        = string
  default     = "Grandpa"
}

variable "purpose_tag" {
  description = "The tag will be applied to every resource in the project"
  type        = string
  default     = "Whiskey"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16" 
}

variable "public_cidrs" {
  description = "CIDRs for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_cidrs" {
  description = "CIDRs for private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "root_table_names" {
  type    = list(string)
  default = ["public", "private_1", "private_2"]
}

variable "ubuntu_account_number" {
  description = "The account number of Canonical"
  type        = string
  default     = "099720109477"
}

variable "key_name" {
  description = "The key name used for instances"
  type        = string
  default     = "terra"
}

variable "web_instance_type" {
  description = "The type of web instances"
  type        = string
  default     = "t3.micro"
}

variable "web_instance_count" {
  type        = number
  default     = 2
}

variable "db_instance_type" {
  description = "The type of database instances"
  type        = string
  default     = "t3.micro"
}

variable "db_instance_count" {
  type        = number
  default     = 2
}

variable "disk_volume_type" {
  description = "The type of disk for all isntances"
  type        = string
  default     = "gp2"
}

variable "web_instance_root_disk_size" {
  description = "The size of root disk for web instances"
  type        = number
  default     = 10
}

variable "web_instance_second_disk_size" {
  description = "The size of secondary disk for web instances"
  type        = number
  default     = 10
}

variable "web_instance_second_disk_device_name" {
  description = "The name of secondary disk for web instances"
  type        = string
  default     = "sdf"
}