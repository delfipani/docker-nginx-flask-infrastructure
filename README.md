# Containerized Infrastructure: Nginx + Flask
This project is part of my **Computer Engineering (UBA)** degree and my specialization in **Cloud/DevOps**. It consists of a basic microservices architecture featuring an application server and a reverse proxy

## Architecture
The project uses **Docker Compose** to orchestrate two services:
1. **Flask App**: A Python 3.11 application server.
2. **Nginx**: Functions as a Reverse Proxy, receiving requests on port 8080 and forwarding them to the Flask container.

## Security & Optimization
- **Non-Root User**: The Flask container runs under an unprivileged user (`appuser`) to minimize security risks.
- **Layer Optimization**: The Dockerfile is structured to leverage Docker's build cache by separating dependency installation from source code.
- **Principle of Least Privilege**: Nginx is the only entry point exposed to the external network.

## Key Learnings
- **Networking**: Implemented a custom bridge network for internal DNS resolution (Nginx discovers `flask-app`by its service name)
- **Persistence**: Explored volume usage for dynamic configuration injection without rebuilding images.
- **Reverse Proxy**: Configured Nginx to decouple the client from backend application.

## How to run
1. Clone the repository
2. Run `docker-compose up -d`.
3. Access `localhost:8080`.

## Future Roadmap
- Implement Bash scripts to automate environment health checks and container log rotation.
- Migrate the local architecture to a Cloud Provider (AWS EC2 / ECS) using Infrastructure as Code (Terraform).
