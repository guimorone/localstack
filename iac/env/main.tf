terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
  required_version = ">= 1.6.0"
}

provider "aws" {
  region = var.region
}

resource "terraform_data" "validation" {
  lifecycle {
    precondition {
      condition     = terraform.workspace != "default"
      error_message = <<EOF
      EOF
    }
  }
}
