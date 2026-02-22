# Script nhanh de restart AIOStreams tren VPS
# Su dung: .\restart-vps.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Restart AIOStreams tren VPS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$action = Read-Host "Chon hanh dong: [1] Restart container [2] Restart tunnel [3] Ca hai (1/2/3)"

if ($action -eq "1" -or $action -eq "3") {
    Write-Host ""
    Write-Host "Restarting container..." -ForegroundColor Yellow
    ssh root@103.116.52.252 -p 10875 "cd ~/aiostreams && docker-compose restart"
    Write-Host "Container restarted!" -ForegroundColor Green
}

if ($action -eq "2" -or $action -eq "3") {
    Write-Host ""
    Write-Host "Restarting Cloudflare Tunnel..." -ForegroundColor Yellow
    ssh root@103.116.52.252 -p 10875 "bash ~/aiostreams/cloudflare-tunnel.sh"
    Write-Host "Tunnel restarted!" -ForegroundColor Green
}

Write-Host ""
Write-Host "Kiem tra trang thai: .\check-vps-health.ps1" -ForegroundColor Cyan
