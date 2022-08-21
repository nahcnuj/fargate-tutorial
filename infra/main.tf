terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = var.profile

  default_tags {
    tags = {
      Name    = "${var.service}_${var.environment}"
      Env     = var.environment
      Service = var.service
    }
  }
}