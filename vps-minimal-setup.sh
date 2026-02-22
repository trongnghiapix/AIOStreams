#!/bin/bash

# Minimal VPS Setup Script - No source code needed
# This uses pre-built Docker image from Docker Hub

set -e

echo "==================================="
echo "   AIOStreams Minimal VPS Setup"
echo "==================================="

# Create app directory
mkdir -p /root/aiostreams
cd /root/aiostreams

# Generate SECRET_KEY
echo "🔑 Generating SECRET_KEY..."
SECRET_KEY=$(openssl rand -hex 32)

# Create .env file
echo "📝 Creating .env file..."
cat > .env << EOF
# AIOStreams Configuration
PORT=3000
BASE_URL=http://nghianguyen.thuevpsgiare.com.vn
SECRET_KEY=${SECRET_KEY}
DATABASE_URI=sqlite://./data/db.sqlite
ADDON_NAME="AIOStreams"
ADDON_ID="aiostreams.trongnghiapix.com"
EOF

# Create docker-compose.yaml
echo "📝 Creating docker-compose.yaml..."
cat > docker-compose.yaml << EOF
services:
  aiostreams:
    image: trongnghiapix/aiostreams:latest
    container_name: aiostreams
    restart: unless-stopped
    ports:
      - '10875:3000'
    env_file:
      - .env
    volumes:
      - ./data:/app/data
EOF

# Create data directory
mkdir -p data

# Pull and start container
echo "📥 Pulling Docker image from Docker Hub..."
docker-compose pull

echo "🚀 Starting AIOStreams..."
docker-compose up -d

# Wait for container
sleep 5

echo ""
echo "==================================="
echo "   Deployment Complete!"
echo "==================================="
echo ""
docker-compose ps
echo ""
echo "🎉 AIOStreams is running!"
echo "📱 Addon URL: http://nghianguyen.thuevpsgiare.com.vn/manifest.json"
echo ""
echo "📊 View logs: docker-compose logs -f"
echo "🔄 Restart: docker-compose restart"
echo "🛑 Stop: docker-compose down"
echo "📥 Update: docker-compose pull && docker-compose up -d"
echo ""
