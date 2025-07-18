Project022A – Production-Grade Jenkins CI/CD Pipeline

**Author**: Noel Kiniben\
**Architecture**: Multi-agent (high availability)\
**Tools Used**: Git/GitHub, Maven, SonarQube, Nexus, Docker, Kubernetes, Jenkins


Pipeline Overview

This Jenkins pipeline implements a multi-stage, production-grade CI/CD workflow using multiple Jenkins agents for high availability and separation of concerns. The stages are logically divided for clarity, isolation, and scalability.

---
Pipeline Breakdown & Tool Integration

1. Source Code Management (GitHub)

- Source code is cloned from a GitHub repository.
- `credentialsId` is securely referenced using Jenkins credentials (GitHub personal access token).

2. Maven Build

- Maven is configured as a Jenkins tool (`maven3.9.1`).
- Runs on a `build-agent` node.
- `mvn clean package -DskipTests` compiles the source code and generates artifacts.

3. SonarQube Static Code Analysis

- SonarQube is configured as a standalone server.
- Integrated into Jenkins using the **SonarScanner plugin**.
- Credentials (`sonarqube-token`) are stored securely in Jenkins and accessed via:
  ```groovy
  environment {
    SONAR_TOKEN = credentials('sonarqube-token')
  }
  ```
- Analysis is executed with `mvn verify sonar:sonar` using the SonarQube server configured under **Manage Jenkins → Configure System**.

4. Artifact Deployment to Nexus

- Nexus is configured as a standalone artifact repository.
- Maven `settings.xml` is configured on the build agent to point to Nexus without hardcoding credentials.
- Nexus credentials are stored securely as `nexus-creds` and passed into the pipeline via:
  ```groovy
  withCredentials([usernamePassword(credentialsId: 'nexus-creds', ...)])
  ```
- `mvn clean deploy -DskipTests` deploys artifacts to Nexus.

5. Docker Image Build & Push

- Docker must be installed and the Jenkins/Ubuntu user must belong to the `docker` group on the `build-agent`.
- Docker images are tagged and pushed to DockerHub using:
  ```groovy
  IMAGE_NAME = 'noeldevops/myapp-dev'
  docker build -t $IMAGE_NAME:$BUILD_NUMBER .
  docker push $IMAGE_NAME:$BUILD_NUMBER
  ```
- Credentials (`dockerhub-creds`) are securely injected using `usernamePassword()`.

6. Kubernetes Deployment

- `kubectl` is installed on a dedicated `deploy-agent`.
- Secure cluster access is managed via Jenkins credentials (Secret File):
  ```groovy
  withCredentials([file(credentialsId: 'kubeconfig-file', variable: 'KCFG_FILE')]) {
    export KUBECONFIG=$KCFG_FILE
  }
  ```
- `kubectl set image` updates the Kubernetes deployment with the new image version.
- The GitHub repo is cloned again because this stage runs on a different agent (isolated workspace).

---

Jenkins Security Practices

Credentials Used and Purpose

| Credential ID       | Type              | Purpose                                |
| ------------------- | ----------------- | -------------------------------------- |
| `285804eb-0ca2-...` | GitHub PAT        | Used for cloning the source repository |
| `sonarqube-token`   | Secret Text       | For authenticating SonarQube analysis  |
| `nexus-creds`       | Username/Password | For deploying artifacts to Nexus       |
| `dockerhub-creds`   | Username/Password | For DockerHub login & image push       |
| `kubeconfig-file`   | Secret File       | For Kubernetes cluster authentication  |

Security Approach

- **No hardcoding of credentials** in the pipeline.
- **Jenkins credentials store** is used to inject secrets securely at runtime.
- Access to credentials is restricted based on roles/permissions in Jenkins.

---

Project Structure (Typical)

```
my-project-007/
├── Jenkinsfile
├── deploy.yaml         # Kubernetes deployment manifest
├── pom.xml             # Maven build descriptor
├── src/                # Source code
└── ...
```

---

Pre-Requisites for Running the Pipeline

Jenkins Setup

- Jenkins configured with **multiple agents** (`build-agent`, `deploy-agent`).
- Required plugins:
  - Maven Integration
  - SonarQube Scanner
  - Docker Pipeline
  - Kubernetes CLI
- Maven tool named `maven3.9.1` added in Jenkins global tools.

Agent Requirements

- **Build Agent**:
  - Maven
  - Docker
  - Added Jenkins user to the Docker group
- **Deploy Agent**:
  - `kubectl`
  - `.kube/config` available via Jenkins secret file

External Services Setup

- **SonarQube** & **Nexus** as standalone services
- **DockerHub** account and repository
- **Kubernetes cluster** with deployment defined in `deploy.yaml`

---

Final Notes

- This pipeline is fully automated and adheres to security best practices.
- Each stage is isolated for performance and failure containment.
- Multi-agent architecture ensures scalability and high availability.
- Credentials and configurations are securely handled using Jenkins best practices.
