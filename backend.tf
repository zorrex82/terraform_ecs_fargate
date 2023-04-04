terraform {
  backend "s3" {
    bucket = "bucket-name-unique"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
