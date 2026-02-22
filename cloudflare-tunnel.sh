#!/bin/bash
cd ~/aiostreams

# Kill any existing cloudflared process
pkill cloudflared

# Start cloudflared in background
nohup ./cloudflared-linux-amd64 tunnel --url http://localhost:80 > cloudflared.log 2>&1 &

# Wait for tunnel to start
sleep 8

# Extract and display the public URL
echo "================================"
echo "Cloudflare Tunnel Started!"
echo "================================"
grep -oP 'https://[a-z0-9-]+\.trycloudflare\.com' cloudflared.log | head -1
echo ""
echo "Full log available at: ~/aiostreams/cloudflared.log"
echo ""
echo "To stop the tunnel, run: pkill cloudflared"
