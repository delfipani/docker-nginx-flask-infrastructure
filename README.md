# Containerized Infrastructure & Orchestration: Nginx + Flask + Kubernetes
This repository serves as a professional showcase of architectural evolution, shifting from locally orchestrated environments to production-ready declarative infrastructure. Designed and implemented under strict software engineering standards as part of my **Computer Engineering** degree and aligned with the **IBM Applied DevOps Professional** curriculum.

## Architecture Overview
The core application consists of a decoupled microservices architecture designed under the principle of least privilege:

1. **Flask Application Layer**: A Python 3.11 web server hosting a backend API. Engineered to run as an unprivileged, non-root user to drastically reduce the container's attack surface.
2. **Nginx Proxy Layer**: Acts as the sole exposed entry point, intercepting inbound traffic on port `8080` and dynamically routing requests to the internal Flask daemon via high-performance upstream protocols.

## Implemented Features
### Local Orchestration (Docker Compose)
Multi-container architecture structured to optimize build cache layers and leverage fully isolated bridge networks. Internal service discovery is managed natively, decoupling frontend proxy configurations from backend networking specs.

### Automated Environment Monitoring & Health Checks
Located in the `/scripts` directory, `healthcheck.sh` is a custom production-grade Bash script that automates system auditing:
- Verifies Docker Daemon operational availability.
- Evaluates specific lifecycle states of running container workloads (`flask-app` & `nginx`).
- Executes explicit HTTP network responsiveness checks targeting the reverse proxy.
- Pipes detailed timestamps and dynamic log tracking to persistent local files (`status.log`), structured to avoid tracking anomalies through `.gitignore`.

### Production-Ready Kubernetes Migration (Declarative Manifests)
Structured within the `/k8s-manifests` directory, the repository features declarative Infrastructure-as-Code (IaC) architectures:
- **`flask-deployment.yaml`**: Configures horizontal auto-scaling topologies (ReplicaSets) initializing isolated Pod groups, structured and audited offline using formal syntax linters (`yamllint`).
- **`flask-service.yaml`**: Establishes immutable `ClusterIP` network abstraction, unifying persistent internal load balancing and dynamic traffic routing toward ephemeral backend workloads.

##  How to Run Locally

### 1. Standalone Docker Compose Setup
```bash
# Clone the repository
git clone [https://github.com/delfipani/docker-nginx-flask-infrastructure.git](https://github.com/delfipani/docker-nginx-flask-infrastructure.git)
cd docker-nginx-flask-infrastructure

# Boot up the stack in detached mode
docker-compose up -d

# Execute the automated health check monitoring suite
bash scripts/healthcheck.sh
```

### 2. Kubernetes Declarative Validation
```bash
# Verify structural integrity using offline dry-runs
kubectl apply -f k8s-manifests/flask-deployment.yaml --dry-run=client --validate=false
kubectl apply -f k8s-manifests/flask-service.yaml --dry-run=client --validate=false
```

