terraform {
  backend "s3" {
    bucket  = "aleks-terraform"
    key     = "State_Development"
    region  = "us-east-1"
  }
}
