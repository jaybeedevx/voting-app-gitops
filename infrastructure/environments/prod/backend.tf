terraform {
  backend "s3" {
    bucket = "tsta1131"
    key    = "prod/eks/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
