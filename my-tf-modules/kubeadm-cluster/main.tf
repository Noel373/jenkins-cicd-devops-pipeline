provider "aws" {
  region = "eu-north-1"
}

resource "aws_security_group" "kubeadm_cluster_sg" {
  name        = "kubeadm-cluster-sg"
  description = "Security group for kubeadm-based Kubernetes cluster"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidrs
  }

  ingress {
    description = "Kubernetes API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = var.api_server_access_cidrs
  }

  ingress {
    description = "Internal Communication - All TCP"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Internal Communication - All UDP"
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    self        = true
  }

  ingress {
    description = "NodePort Access"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = var.nodeport_allowed_cidrs
  }

  egress {
    description = "Allow all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kubeadm-cluster-sg"
  }
}

resource "aws_instance" "master" {
  ami                         = var.ami_id
  instance_type               = "t3.small"
  subnet_id                   = var.public_subnet_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.kubeadm_cluster_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "master-node"
  }
}

resource "aws_instance" "worker" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.kubeadm_cluster_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "worker-node"
  }
}

