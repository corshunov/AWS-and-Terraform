terraform {
  backend "s3" {
    bucket  = "whiskey-website-state"
    key     = "application"
    region  = "us-east-1"
  }
}
