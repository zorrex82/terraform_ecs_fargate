terraform {
  backend "s3" {
    bucket = "terraform-tfstate-edinor"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
