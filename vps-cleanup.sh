#!/bin/bash

# VPS Cleanup Script
# Clean up unused Docker resources and free up disk space

echo "==================================="
echo "   VPS Cleanup Script"
echo "==================================="

# Show current disk usage
echo "📊 Current disk usage:"
df -h /

echo ""
echo "🧹 Cleaning up Docker resources..."

# Stop all containers
docker-compose down 2>/dev/null || true

# Remove stopped containers
docker container prune -f

# Remove unused images (keep only images in use)
docker image prune -a -f

# Remove unused volumes
docker volume prune -f

# Remove unused networks
docker network prune -f

# Clean Docker build cache
docker builder prune -a -f

echo ""
echo "📊 Disk usage after cleanup:"
df -h /

echo ""
echo "🐳 Docker images:"
docker images

echo ""
echo "✅ Cleanup complete!"
