provider "aws" {
  region  = var.aws_region

  default_tags {
    tags = {
      Environment = var.env_tag
      Owner       = var.owner_tag
      Purpose     = var.purpose_tag
    }
  }
}
