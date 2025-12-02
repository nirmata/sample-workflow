terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Default provider (ignored for the resource below)
provider "aws" {
  region = "us-west-1"
}

# Secondary provider targeting the WRONG region
provider "aws" {
  alias  = "wrong_region"
  region = "us-east-1"
}

resource "aws_s3_bucket" "violation_bucket" {
  provider = aws.wrong_region # Forces creation in us-east-1
  
  bucket = "nirmata-demo-bad-bucket-${random_id.suffix.hex}" 

  tags = {
    Compliance  = "Fail"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}
