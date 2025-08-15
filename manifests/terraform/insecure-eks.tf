# Insecure EKS configuration that violates security best practices
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

# EKS Cluster with insecure configuration
resource "aws_eks_cluster" "insecure_cluster" {
  name     = "insecure-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
    
    # Insecure: Public access enabled (violation)
    endpoint_public_access = true
    endpoint_private_access = false
    
    # Insecure: Public CIDR blocks (violation)
    public_access_cidrs = ["0.0.0.0/0"]
  }

  # Insecure: No encryption configuration (violation)
  # Insecure: No logging configuration (violation)
  
  tags = {
    Environment = "production"
    Security    = "insecure"
  }
}

# Insecure IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "insecure-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

# Insecure: Overly permissive policy (violation)
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Insecure: Additional overly permissive policies (violation)
resource "aws_iam_role_policy" "eks_cluster_additional_policy" {
  name = "eks-cluster-additional-policy"
  role = aws_iam_role.eks_cluster_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "*"
        Resource = "*"
      }
    ]
  })
}

# EKS Node Group with insecure configuration
resource "aws_eks_node_group" "insecure_node_group" {
  cluster_name    = aws_eks_cluster.insecure_cluster.name
  node_group_name = "insecure-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.subnet_ids

  # Insecure: No scaling configuration (violation)
  # Insecure: No update configuration (violation)

  instance_types = ["t3.medium"]

  # Insecure: No disk size specification (violation)
  # Insecure: No AMI type specification (violation)

  tags = {
    Environment = "production"
    Security    = "insecure"
  }
}

# Insecure IAM Role for EKS Nodes
resource "aws_iam_role" "eks_node_role" {
  name = "insecure-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Insecure: Overly permissive node policies (violation)
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

# Insecure: Additional overly permissive node policy (violation)
resource "aws_iam_role_policy" "eks_node_additional_policy" {
  name = "eks-node-additional-policy"
  role = aws_iam_role.eks_node_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "*"
        Resource = "*"
      }
    ]
  })
}

# Variables
variable "subnet_ids" {
  description = "Subnet IDs for EKS cluster"
  type        = list(string)
  default     = ["subnet-12345678", "subnet-87654321"]
}
