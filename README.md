# jenkins cicd devops pipeline

**Author:** Noel Kiniben  
**Architecture:** Multi-agent Jenkins (High Availability)

## Overview
This project demonstrates a **production-ready CI/CD pipeline** built with Jenkins and modern DevOps tools.  
It covers the full software delivery lifecycle — from source code to Kubernetes deployment — with strong security and scalability practices.

## Tech Stack
- Jenkins (Multi-Agent)
- Git & GitHub
- Maven
- SonarQube
- Nexus Repository
- Docker & DockerHub
- Kubernetes
- Ansible & Bash automation

## Key Features
- Multi-stage Jenkins pipeline with isolated agents
- Secure credential management using Jenkins Credentials Store
- Automated build, test, and artifact publishing
- Static code analysis with SonarQube
- Docker image build and push
- Kubernetes deployment automation
- Ansible playbooks and Bash scripts for package installation and configuration

## Pipeline Flow
1. **Source Control** – Code cloned securely from GitHub  
2. **Build** – Maven build on dedicated build agent  
3. **Code Quality** – SonarQube static analysis  
4. **Artifact Management** – Artifacts published to Nexus  
5. **Containerization** – Docker image build and push to DockerHub  
6. **Deployment** – Kubernetes deployment using `kubectl` on a deploy agent  

## Security Best Practices
- No hard-coded secrets
- All credentials injected securely at runtime
- Separation of build and deploy responsibilities
- Role-based access in Jenkins
