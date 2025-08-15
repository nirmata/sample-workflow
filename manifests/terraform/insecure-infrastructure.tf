# Insecure infrastructure configuration that violates security best practices
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# Insecure VPC configuration
resource "aws_vpc" "insecure_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name     = "insecure-vpc"
    Security = "insecure"
  }
}

# Insecure: Public subnets with auto-assign public IPs (violation)
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.insecure_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true  # Insecure: Auto-assign public IPs

  tags = {
    Name     = "public-subnet-1"
    Security = "insecure"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.insecure_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true  # Insecure: Auto-assign public IPs

  tags = {
    Name     = "public-subnet-2"
    Security = "insecure"
  }
}

# Insecure: Internet Gateway (violation - allows public access)
resource "aws_internet_gateway" "insecure_igw" {
  vpc_id = aws_vpc.insecure_vpc.id

  tags = {
    Name     = "insecure-internet-gateway"
    Security = "insecure"
  }
}

# Insecure: Route table with public access (violation)
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.insecure_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.insecure_igw.id
  }

  tags = {
    Name     = "public-route-table"
    Security = "insecure"
  }
}

# Insecure: Route table association (violation)
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Insecure: Security Group with overly permissive rules (violation)
resource "aws_security_group" "insecure_sg" {
  name        = "insecure-security-group"
  description = "Insecure security group with overly permissive rules"
  vpc_id      = aws_vpc.insecure_vpc.id

  # Insecure: Allow all inbound traffic (violation)
  ingress {
    description = "Allow all inbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Insecure: Allow all outbound traffic (violation)
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "insecure-security-group"
    Security = "insecure"
  }
}

# Insecure: EC2 Instance with public IP (violation)
resource "aws_instance" "insecure_instance" {
  ami                    = "ami-12345678"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.insecure_sg.id]
  
  # Insecure: Associate public IP (violation)
  associate_public_ip_address = true
  
  # Insecure: No key pair specified (violation)
  # Insecure: No IAM instance profile (violation)
  
  # Insecure: User data with hardcoded credentials (violation)
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "admin:password123" > /etc/httpd/htpasswd
              echo "<h1>Insecure Web Server</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name     = "insecure-instance"
    Security = "insecure"
  }
}

# Insecure: S3 Bucket with public access (violation)
resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "insecure-bucket-${random_string.bucket_suffix.result}"

  tags = {
    Name     = "insecure-bucket"
    Security = "insecure"
  }
}

# Insecure: S3 Bucket public access block disabled (violation)
resource "aws_s3_bucket_public_access_block" "insecure_bucket_public_access" {
  bucket = aws_s3_bucket.insecure_bucket.id

  block_public_acls       = false  # Insecure: Allow public ACLs
  block_public_policy     = false  # Insecure: Allow public policies
  ignore_public_acls      = false  # Insecure: Don't ignore public ACLs
  restrict_public_buckets = false  # Insecure: Don't restrict public buckets
}

# Insecure: S3 Bucket policy allowing public read (violation)
resource "aws_s3_bucket_policy" "insecure_bucket_policy" {
  bucket = aws_s3_bucket.insecure_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.insecure_bucket.arn}/*"
      }
    ]
  })
}

# Random string for unique bucket names
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}
