# Script de update code tu upstream va deploy len VPS
# Su dung: .\update-from-upstream.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Update tu Upstream AIOStreams" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Kiem tra co thay doi chua commit khong
Write-Host "Kiem tra working directory..." -ForegroundColor Yellow
$status = git status --porcelain
if ($status) {
    Write-Host "WARNING: Co thay doi chua commit:" -ForegroundColor Red
    git status --short
    Write-Host ""
    $continue = Read-Host "Ban co muon stash cac thay doi nay khong? (y/n)"
    if ($continue -eq 'y') {
        git stash save "Auto-stash before update $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        Write-Host "Da stash thay doi" -ForegroundColor Green
    } else {
        Write-Host "Huy update" -ForegroundColor Red
        exit 1
    }
}

# Fetch updates tu upstream
Write-Host "Fetch updates tu upstream..." -ForegroundColor Yellow
git fetch upstream

# Check branch hien tai
$currentBranch = git rev-parse --abbrev-ref HEAD
Write-Host "Branch hien tai: $currentBranch" -ForegroundColor Cyan

# Merge upstream/main vao branch hien tai
Write-Host "Merge upstream/main vao $currentBranch..." -ForegroundColor Yellow
$mergeResult = git merge upstream/main 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "WARNING: CO CONFLICT!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Cac file bi conflict:" -ForegroundColor Yellow
    git diff --name-only --diff-filter=U
    Write-Host ""
    Write-Host "Hay resolve conflict thu cong:" -ForegroundColor Yellow
    Write-Host "  1. Sua cac file bi conflict" -ForegroundColor White
    Write-Host "  2. git add <file>" -ForegroundColor White
    Write-Host "  3. git commit" -ForegroundColor White
    Write-Host "  4. Chay lai script nay" -ForegroundColor White
    exit 1
}

Write-Host "Merge thanh cong!" -ForegroundColor Green

# Push len origin
Write-Host ""
Write-Host "Push len GitHub..." -ForegroundColor Yellow
git push origin $currentBranch

Write-Host "Da push len GitHub!" -ForegroundColor Green

# Build lai Docker image
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Rebuild Docker Image" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$rebuild = Read-Host "Ban co muon rebuild Docker image khong? (y/n)"
if ($rebuild -ne 'y') {
    Write-Host "Bo qua rebuild" -ForegroundColor Yellow
    exit 0
}

# Build TypeScript
Write-Host "Building TypeScript..." -ForegroundColor Yellow
pnpm build

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

# Build Docker image
Write-Host ""
Write-Host "Building Docker image..." -ForegroundColor Yellow
docker build -f Dockerfile.prebuilt -t trongnghiapix/aiostreams:latest .

if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Docker image built!" -ForegroundColor Green

# Push to Docker Hub
Write-Host ""
$push = Read-Host "Push len Docker Hub? (y/n)"
if ($push -eq 'y') {
    Write-Host "Pushing to Docker Hub..." -ForegroundColor Yellow
    docker push trongnghiapix/aiostreams:latest
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Docker push failed!" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "Pushed to Docker Hub!" -ForegroundColor Green
}

# Deploy to VPS
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Deploy len VPS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$deploy = Read-Host "Deploy len VPS? (y/n)"
if ($deploy -eq 'y') {
    Write-Host "Pulling new image on VPS..." -ForegroundColor Yellow
    ssh root@103.116.52.252 -p 10875 "cd ~/aiostreams && docker-compose pull && docker-compose up -d --force-recreate"
    
    Write-Host ""
    Write-Host "Deployed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Kiem tra logs:" -ForegroundColor Yellow
    Write-Host "  ssh root@103.116.52.252 -p 10875" -ForegroundColor White
    Write-Host "  cd ~/aiostreams && docker logs -f aiostreams" -ForegroundColor White
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  HOAN THANH!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
