terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.72.1"
      configuration_aliases = [aws.us-east-1]
    }
  }
}