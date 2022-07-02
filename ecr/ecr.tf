terraform {

  required_version = "~> 1.2"
  backend "s3" {
    bucket = "pgf-state-store"
    key    = "ecr"
    region = "eu-west-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_ecr_repository" "pgf" {
  name = "pgf"
}
