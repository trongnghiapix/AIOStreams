# Kiem tra xem upstream co update moi khong
# Su dung: .\check-upstream-updates.ps1

Write-Host "Kiem tra updates tu upstream..." -ForegroundColor Cyan
Write-Host ""

# Fetch upstream
git fetch upstream --quiet

# So sanh
$behind = git rev-list HEAD..upstream/main --count
$ahead = git rev-list upstream/main..HEAD --count

if ($behind -eq 0) {
    Write-Host "Code da up-to-date voi upstream!" -ForegroundColor Green
} else {
    Write-Host "Co $behind commit moi tu upstream:" -ForegroundColor Yellow
    Write-Host ""
    git log HEAD..upstream/main --oneline --no-decorate
    Write-Host ""
    Write-Host "De update, chay: .\update-from-upstream.ps1" -ForegroundColor Cyan
}

if ($ahead -gt 0) {
    Write-Host ""
    Write-Host "Ban co $ahead commit chua merge vao upstream" -ForegroundColor Cyan
}
