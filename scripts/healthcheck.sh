#!/bin/bash

# Automation script to check the health of the Docker environment
# Created by Delfina Paniccia 

# Define directory and log file paths dynamically
SCRIPT_DIR="$(dirname "$0")"
LOG_FILE="$SCRIPT_DIR/status.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

echo "========================================="
echo "📊 Initializing infrastructure check..."
echo "========================================="

# Log the start of the check
echo "--- Health Check Run: $TIMESTAMP ---" >> "$LOG_FILE"

# 1. Check if Docker daemon is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ ERROR: Docker daemon is not running on the system."
    echo "[$TIMESTAMP] ERROR: Docker daemon is down." >> "$LOG_FILE"
    exit 1
fi
echo "✅ Docker Daemon: OK"
echo "[$TIMESTAMP] Docker Daemon: OK" >> "$LOG_FILE"

# 2. Check specific containers operational status
CONTAINERS=("flask-app" "nginx")

for container in "${CONTAINERS[@]}"; do
    RUNNING=$(docker ps -q -f name=^/${container}$)
    
    if [ -n "$RUNNING" ]; then
        echo "✅ Container [$container]: RUNNING"
        echo "[$TIMESTAMP] Container [$container]: RUNNING" >> "$LOG_FILE"
    else
        echo "❌ ALERT: Container [$container] is DOWN or does not exist."
        echo "[$TIMESTAMP] ALERT: Container [$container] is DOWN." >> "$LOG_FILE"
    fi
done

# 3. Network Verification (HTTP Request to Reverse Proxy)
echo "-----------------------------------------"
echo "🌐 Testing Network Responsiveness..."

# Request HTTP code only to verify connection status
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://localhost:8080)

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "✅ HTTP Connection: OK (Status 200)"
    echo "[$TIMESTAMP] HTTP Connection: OK (Status 200)" >> "$LOG_FILE"
else
    echo "❌ ALERT: HTTP Service Unreachable (Status received: $HTTP_STATUS)"
    echo "[$TIMESTAMP] ALERT: HTTP Connection Failed (Status: $HTTP_STATUS)" >> "$LOG_FILE"
fi

echo "========================================="
echo "🏁 Check completed. Logs saved to scripts/status.log"
echo "========================================="