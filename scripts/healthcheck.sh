#!/bin/bash

# Automation script to check the health of the Docker environment
# Created by Delfina Paniccia - DevOps/Support Approach

echo "========================================="
echo "📊 Initializing infrastructure check..."
echo "========================================="

# 1. Check if Docker daemon is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ ERROR: Docker daemon is not running on the system."
    exit 1
fi
echo "✅ Docker Daemon: OK"

# 2. Check specific containers
CONTAINERS=("flask-app" "nginx")

for container in "${CONTAINERS[@]}"; do
    # docker ps -q filters by name and returns the ID if running
    RUNNING=$(docker ps -q -f name=^/${container}$)
    
    if [ -n "$RUNNING" ]; then
        echo "✅ Container [$container]: RUNNING"
    else
        echo "❌ ALERT: Container [$container] is DOWN or does not exist."
    fi
done

echo "========================================="
echo "🏁 Check completed."
echo "========================================="