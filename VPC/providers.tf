terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.38.0"
    }
  }
}

# Configure AWS provider
provider "aws" {
  # Set region to us-east-1
  region = var.region
  alias  = "Virgo"
}
