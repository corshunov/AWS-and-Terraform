variable "aws_region" {
  description = "AWS region to deploy all resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16" 
}

variable "number_of_azs" {
  description = "Number of availability zones"
  type        = number
  default     = 2
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

variable "availability_zones" {
  description = "AZs for public and private subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "web_instance_type" {
  description = "The type of web EC2 instances"
  type        = string
  default     = "t3.micro"
}

variable "db_instance_type" {
  description = "The type of database EC2 instances"
  type        = string
  default     = "t3.micro"
}

variable "number_web_instances" {
  description = "The number of web EC2 instances"
  type        = number
  default     = 2
}

variable "number_db_instances" {
  description = "The number of database EC2 instances"
  type        = number
  default     = 2
}

variable "root_disk_size" {
  description = "The size of the root disk"
  type        = number
  default     = 10
}

variable "secondary_disk_size" {
  description = "The size of the secondary disk"
  type        = number
  default     = 10
}

variable "key_name" {
  description = "The key name of the Key Pair to use for AWS instances"
  type        = string
  default     = "terra"
}

variable "owner_tag" {
  description = "The owner tag will be applied to every resource in the project through the 'default_tags' feature"
  type        = string
  default     = "Grandpa"
}

variable "purpose_tag" {
  description = "The purpose tag will be applied to all AWS instances of whiskey website"
  type        = string
  default     = "Whiskey"
}

variable "name_tag" {
  description = "The name tag will be applied to all AWS instances of whiskey website"
  type        = string
  default     = "Nginx"
}

variable "ubuntu_account_number" {
  description = "The account number of Canonical"
  type        = string
  default     = "099720109477"
}
