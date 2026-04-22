terraform {
  backend "s3" {
    bucket         = "voting-app-tfstate-<ACCOUNT_ID>"   # reuse existing bucket
    key            = "platform/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}