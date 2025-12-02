provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_user" "bad_user" {
  name = "demo-user-no-tags"
  
}
