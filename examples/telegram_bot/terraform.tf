terraform {
  required_version = ">= 1.9.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.66.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.5.0"
    }
  }

  backend "s3" {
    bucket = "my-terraform-states" # Replace with your bucket name"
    key    = "telegram-bot/terraform.tfstate"
    region = "us-east-1"
  }
}
