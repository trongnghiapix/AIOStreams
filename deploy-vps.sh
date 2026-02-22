#!/bin/bash

# AIOStreams VPS Deploy Script
# Run this on your VPS after SSH-ing in

set -e  # Exit on error

echo "==================================="
echo "   AIOStreams VPS Deployment"
echo "==================================="

# 1. Update system
echo "📦 Updating system..."
apt update && apt upgrade -y

# 2. Install Docker if not installed
if ! command -v docker &> /dev/null; then
    echo "🐳 Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
else
    echo "✅ Docker already installed"
fi

# 3. Install Docker Compose if not installed
if ! command -v docker-compose &> /dev/null; then
    echo "📦 Installing Docker Compose..."
    apt install docker-compose -y
else
    echo "✅ Docker Compose already installed"
fi

# 4. Clone repository
echo "📥 Cloning AIOStreams repository..."
cd /root
if [ -d "AIOStreams" ]; then
    echo "⚠️  AIOStreams directory exists, pulling latest changes..."
    cd AIOStreams
    git pull
else
    git clone https://github.com/trongnghiapix/AIOStreams.git
    cd AIOStreams
fi

# 5. Generate SECRET_KEY
echo "🔑 Generating SECRET_KEY..."
SECRET_KEY=$(openssl rand -hex 32)

# 6. Create .env file
echo "📝 Creating .env file..."
cat > .env << EOF
# AIOStreams Configuration

# --- Network Configuration ---
PORT=3000
BASE_URL=http://103.116.52.252:10875

# --- Security ---
SECRET_KEY=${SECRET_KEY}

# --- Database ---
DATABASE_URI=sqlite://./data/db.sqlite

# --- Addon Identification ---
ADDON_NAME="AIOStreams"
ADDON_ID="aiostreams.trongnghiapix.com"

# --- Optional: Addon Password ---
# ADDON_PASSWORD=your_password_here
EOF

echo "✅ .env file created with SECRET_KEY: ${SECRET_KEY}"

# 7. Build and run Docker
echo "🐳 Building Docker image (this may take 5-10 minutes)..."
docker-compose -f compose.vps.yaml build

echo "🚀 Starting AIOStreams..."
docker-compose -f compose.vps.yaml up -d

# 8. Wait for container to start
echo "⏳ Waiting for container to start..."
sleep 10

# 9. Check status
echo ""
echo "==================================="
echo "   Deployment Complete!"
echo "==================================="
echo ""
docker-compose -f compose.vps.yaml ps
echo ""
echo "🎉 AIOStreams is now running!"
echo "📱 Add to Stremio: http://103.116.52.252:10875/manifest.json"
echo ""
echo "📊 View logs: docker-compose -f compose.vps.yaml logs -f"
echo "🔄 Restart: docker-compose -f compose.vps.yaml restart"
echo "🛑 Stop: docker-compose -f compose.vps.yaml down"
echo ""
