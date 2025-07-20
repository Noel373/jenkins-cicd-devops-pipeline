resource "aws_instance" "app" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = data.terraform_remote_state.vpc.outputs.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = var.name  # e.g., "sonarqube", "nexus"
  }
}
provider "aws" {
  region = var.region
}


resource "aws_security_group" "app_sg" {
  name        = "${var.name}-sg"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  description = "Allow basic access for ${var.name}"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg"
  }
}
