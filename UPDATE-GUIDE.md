# 🔄 Hướng Dẫn Update từ Upstream

## Quy trình update khi upstream có thay đổi

### 1. Kiểm tra xem có update mới không

```powershell
.\check-upstream-updates.ps1
```

### 2. Nếu có update, chạy script tự động

```powershell
.\update-from-upstream.ps1
```

Script sẽ tự động:

- ✅ Fetch updates từ upstream
- ✅ Merge vào branch hiện tại
- ✅ Push lên GitHub (fork của bạn)
- ✅ Build TypeScript
- ✅ Build Docker image
- ✅ Push lên Docker Hub
- ✅ Deploy lên VPS

### 3. Nếu có conflict

Script sẽ báo file nào bị conflict. Bạn cần:

1. **Resolve conflict thủ công:**

   ```powershell
   # Mở file bị conflict, sửa lại
   code packages/core/src/db/schemas.ts

   # Sau khi sửa xong
   git add packages/core/src/db/schemas.ts
   git commit -m "Resolve merge conflict"
   ```

2. **Chạy lại script:**
   ```powershell
   .\update-from-upstream.ps1
   ```

---

## 🔧 Các lệnh hữu ích

### Kiểm tra status hiện tại

```powershell
git status
git log --oneline -10
```

### Xem các thay đổi của bạn so với upstream

```powershell
git diff upstream/main
```

### Xem commit history

```powershell
git log --oneline --graph --all --decorate
```

### Nếu muốn update thủ công (không dùng script)

```powershell
# 1. Fetch upstream
git fetch upstream

# 2. Merge vào branch hiện tại
git merge upstream/main

# 3. Resolve conflicts nếu có, rồi:
git add .
git commit -m "Merge upstream changes"

# 4. Push lên GitHub
git push origin feature/subtitle-fansub-support

# 5. Build
pnpm build

# 6. Build Docker image
docker build -f Dockerfile.prebuilt -t trongnghiapix/aiostreams:latest .

# 7. Push to Docker Hub
docker push trongnghiapix/aiostreams:latest

# 8. Deploy lên VPS
ssh root@103.116.52.252 -p 10875
cd ~/aiostreams
docker-compose pull
docker-compose up -d --force-recreate
```

---

## 🚨 Troubleshooting

### Build failed do conflict chưa resolve

- Mở files bị conflict
- Tìm và sửa các dòng `<<<<<<`, `======`, `>>>>>>`
- `git add <file>` và `git commit`

### Docker build failed

- Kiểm tra `pnpm build` có lỗi không
- Check xem dist folders có được tạo không: `ls packages/*/dist`

### VPS không pull được image mới

- Kiểm tra Docker Hub: https://hub.docker.com/r/trongnghiapix/aiostreams/tags
- Verify image đã được push: `docker images | grep aiostreams`

---

## 📌 Files quan trọng bạn đã modify

Khi merge upstream, các file này có thể bị conflict:

1. `packages/core/src/db/schemas.ts` (line 849-850)
   - Added: `subtitleLanguages`, `fansubLanguages`

2. `packages/core/src/presets/nekoBt.ts` (line 173-185)
   - Extract và save subtitle/fansub languages

3. `packages/core/src/formatters/base.ts` (line 52-53, 321-395)
   - Added 4 new fields với emoji support và sorting

Nếu các file này bị conflict, ưu tiên giữ lại code của bạn và merge manually.

---

## ⏰ Tần suất nên check update

- **Hàng tuần:** Check xem có update mới không
- **Khi có bug:** Xem upstream đã fix chưa
- **Trước khi thêm feature mới:** Update để code mới nhất

---

## 🆘 Cần help?

Nếu gặp vấn đề khi update, hãy:

1. Check git status: `git status`
2. Check logs: `git log --oneline -5`
3. Backup code: `git stash` hoặc tạo branch mới
