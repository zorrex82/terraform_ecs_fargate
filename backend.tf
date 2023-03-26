terraform {
  backend "s3" {
    bucket = "terraform-tfstate-edinorjr"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
