terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "292944470513-tfstate"
    region         = "us-east-1"
    key            = "tfstate/vpc/terraform.tfstate"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

provider "aws" {
  default_tags {
    tags = {
      EnvironmentType = "lab"
      CreatedBy       = "terraform"
    }
  }
}
