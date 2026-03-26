#!/bin/bash
# Script to build and run the Docker container

set -e  # Exit on error

echo "===== Building Docker container ====="
docker build -t kali-mcp-server .

echo "===== Running Docker container ====="
echo "The server will be available at http://localhost:8000/sse"
docker run -p 8000:8000 kali-mcp-server