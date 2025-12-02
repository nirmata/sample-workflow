terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "violation_server" {
  ami = "ami-014d05e6b29837e5d" 

  instance_type = "t2.micro" 

  tags = {
    Name = "Demo-Violation"
  }
}
