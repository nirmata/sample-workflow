provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "bad_admin_role" {
  name = "demo-prohibited-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Owner       = "DemoTeam"
    Environment = "Test"
  }
}

resource "aws_iam_role_policy_attachment" "admin_attach" {
  role       = aws_iam_role.bad_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
