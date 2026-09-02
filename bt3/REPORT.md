# BÁO CÁO THỰC HÀNH: ĐÓNG GÓI & ĐẨY DOCKER IMAGE LÊN GITHUB CONTAINER REGISTRY (GHCR.IO)

## 1. Nguyên nhân lỗi `denied: requested access to the resource is denied`
- **Xác thực không đúng chuẩn:** Sử dụng mật khẩu tài khoản GitHub cá nhân thay vì **Personal Access Token (PAT)** có quyền ghi registry (`write:packages`).
- **Quy tắc đặt tên Tag:** Tên image chưa tuân thủ chuẩn namespace của GitHub Container Registry (`ghcr.io/<github_username_chu_thuong>/<ten_image>:<tag>`).

---

## 2. Các bước thực hiện chi tiết

### Bước 1: Tạo Personal Access Token (PAT) trên GitHub
1. Truy cập **GitHub** -> Chọn **Settings** (ở góc trên bên phải avatar cá nhân).
2. Cuộn xuống chọn **Developer settings** -> **Personal access tokens** -> **Tokens (classic)**.
3. Nhấn **Generate new token (classic)**:
   - **Note:** `GHCR Docker CLI Access`
   - **Expiration:** Chọn thời gian phù hợp (ví dụ: 30 days hoặc 90 days).
   - **Select scopes:** Tích chọn các quyền sau:
     - `write:packages` (Tự động kích hoạt `read:packages`)
     - `delete:packages` (Tùy chọn)
     - `repo` (Khuyến nghị nếu image liên kết với repo private)
4. Nhấn **Generate token** và sao chép (copy) chuỗi token được tạo ra (lưu ý: token chỉ hiển thị 1 lần).

---

### Bước 2: Đăng nhập vào GitHub Container Registry bằng Docker CLI
Mở Terminal / PowerShell và thực hiện lệnh đăng nhập:

```bash
# Cách 1: Sử dụng biến môi trường (Bảo mật, tránh lưu token vào lịch sử terminal)
# Trên PowerShell:
$env:CR_PAT="<TOKEN_GITHUB_CUA_BAN>"
echo $env:CR_PAT | docker login ghcr.io -u <GITHUB_USERNAME> --password-stdin

# Trên Linux / macOS / Git Bash:
export CR_PAT="<TOKEN_GITHUB_CUA_BAN>"
echo $CR_PAT | docker login ghcr.io -u <GITHUB_USERNAME> --password-stdin
```

*Hoặc cách gõ trực tiếp:*
```bash
docker login ghcr.io -u <GITHUB_USERNAME>
# Khi terminal yêu cầu Password, dán Personal Access Token (PAT) vừa tạo vào và Enter.
```

> **Kết quả mong đợi:** `Login Succeeded`

---

### Bước 3: Build Docker Image tại máy local
Tại thư mục chứa file `Dockerfile` của `payment-service`:

```bash
docker build -t payment-service:1.0.0 .
```

---

### Bước 4: Gắn Tag (Tagging) đúng chuẩn GHCR
> **Lưu ý quan trọng:** GHCR yêu cầu GitHub Username phải viết hoàn toàn bằng **chữ thường** (lowercase).

```bash
docker tag payment-service:1.0.0 ghcr.io/<github_username_chu_thuong>/payment-service:1.0.0
```

*Ví dụ với username `dth251`:*
```bash
docker tag payment-service:1.0.0 ghcr.io/dth251/payment-service:1.0.0
```

---

### Bước 5: Đẩy (Push) Image lên GHCR
```bash
docker push ghcr.io/<github_username_chu_thuong>/payment-service:1.0.0
```

*Ví dụ:*
```bash
docker push ghcr.io/dth251/payment-service:1.0.0
```

---

## 3. Tổng hợp danh sách câu lệnh CLI đã thực hiện

```bash
# 1. Đăng nhập GHCR
echo "<YOUR_PAT_TOKEN>" | docker login ghcr.io -u <YOUR_GITHUB_USERNAME> --password-stdin

# 2. Xây dựng image
docker build -t payment-service:1.0.0 .

# 3. Gắn tag theo chuẩn namespace GitHub
docker tag payment-service:1.0.0 ghcr.io/<YOUR_GITHUB_USERNAME>/payment-service:1.0.0

# 4. Đẩy image lên GitHub Container Registry
docker push ghcr.io/<YOUR_GITHUB_USERNAME>/payment-service:1.0.0
```

---

## 4. Kết quả & Đường dẫn nộp bài
- **Trạng thái đăng nhập:** `Login Succeeded`
- **URL Package:** `https://github.com/<YOUR_GITHUB_USERNAME>?tab=packages` hoặc `https://github.com/users/<YOUR_GITHUB_USERNAME>/packages/container/package/payment-service`
- **Ảnh minh chứng:** *(Đính kèm ảnh chụp màn hình terminal `Login Succeeded` / `docker push` thành công và màn hình giao diện Packages trên GitHub)*
