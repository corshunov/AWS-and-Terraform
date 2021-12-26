variable "vpc_id" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "subnet_ids" {
  type = list(string)
}

variable "disk_volume_type" {
  type = string
}

variable "root_disk_size" {
  type = number
}

variable "second_disk_size" {
  type = number
}

variable "second_disk_device_name" {
  type = string
}
