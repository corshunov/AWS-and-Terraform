terraform {
  backend "s3" {
    bucket  = "aleks-terraform"
    key     = "State_Production"
    region  = "us-east-1"
  }
}
