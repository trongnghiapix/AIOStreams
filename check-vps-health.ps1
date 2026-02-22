# Kiem tra trang thai VPS va addon
# Su dung: .\check-vps-health.ps1

Write-Host "Kiem tra trang thai VPS..." -ForegroundColor Cyan
Write-Host ""

# Check container status
Write-Host "=== Docker Container ===" -ForegroundColor Yellow
ssh root@103.116.52.252 -p 10875 "cd ~/aiostreams && docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"

Write-Host ""
Write-Host "=== Service Health ===" -ForegroundColor Yellow
$response = ssh root@103.116.52.252 -p 10875 "curl -s http://localhost:80/stremio/manifest.json | head -c 200"

if ($response -match '"name":"AIOStreams"') {
    Write-Host "Service dang hoat dong tot!" -ForegroundColor Green
} else {
    Write-Host "WARNING: Service khong tra loi!" -ForegroundColor Red
    Write-Host "Chay de xem logs: ssh root@103.116.52.252 -p 10875 'docker logs aiostreams'" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Cloudflare Tunnel ===" -ForegroundColor Yellow
$tunnelRunning = ssh root@103.116.52.252 -p 10875 "ps aux | grep cloudflared | grep -v grep"
if ($tunnelRunning) {
    Write-Host "Cloudflare Tunnel dang chay" -ForegroundColor Green
    $url = ssh root@103.116.52.252 -p 10875 "grep -oP 'https://[a-z0-9-]+\.trycloudflare\.com' ~/aiostreams/cloudflared.log | tail -1"
    if ($url) {
        Write-Host "Public URL: $url" -ForegroundColor Cyan
    }
} else {
    Write-Host "WARNING: Cloudflare Tunnel khong chay!" -ForegroundColor Red
    Write-Host "Chay de khoi dong: ssh root@103.116.52.252 -p 10875 'bash ~/aiostreams/cloudflare-tunnel.sh'" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Disk Usage ===" -ForegroundColor Yellow
ssh root@103.116.52.252 -p 10875 "df -h / | tail -1"

Write-Host ""
Write-Host "=== Memory Usage ===" -ForegroundColor Yellow
ssh root@103.116.52.252 -p 10875 "free -h | grep -E 'Mem:|Swap:'"
