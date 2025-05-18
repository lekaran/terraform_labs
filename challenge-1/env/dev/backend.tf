terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "tf-bck"
    key    = "labs_1/terraform.tfstate"
    region = "eu-west-3"
  }
}