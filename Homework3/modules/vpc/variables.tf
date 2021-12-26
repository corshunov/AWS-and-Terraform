variable "vpc_cidr" {
  type        = string
}

variable "public_cidrs" {
  description = "CIDRs for public subnets"
  type        = list(string)
}

variable "private_cidrs" {
  description = "CIDRs for private subnets"
  type        = list(string)
}

variable "route_tables" {
  type    = list(string)
  default = ["public", "private_1", "private_2"]
}
