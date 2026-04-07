# Elder Guard Mobile App

Ứng dụng di động `Elder Guard` được phát triển bằng Flutter, ưu tiên Android, và đang được dùng như app demo cho các luồng chăm sóc người cao tuổi: đăng nhập, vùng an toàn, giám sát camera demo, nhận cảnh báo push từ backend và điều hướng theo sự kiện.

## Trạng thái hiện tại

- Đa ngôn ngữ `vi` và `en`.
- Có luồng đăng nhập/đăng ký và bootstrap session.
- Trang chủ đã được thay bằng dashboard dịch vụ.
- Có màn hình thiết lập vùng an toàn với bản đồ demo.
- Có màn hình giám sát camera demo, trang chi tiết camera và pull-to-refresh.
- Có trung tâm thông báo push và hỗ trợ mở đúng camera từ cảnh báo backend.
- Có hồ sơ sức khỏe demo và menu cơ bản.

## Tính năng chính

### 1. Trang chủ dạng dashboard

- Home hiển thị dạng các ô dịch vụ thay cho UI cũ.
- Có các mục: `Thiết lập vùng an toàn`, `Giám sát camera`, `Thông báo`, `Hồ sơ sức khỏe`, `Nhắc uống thuốc`, `Liên hệ gia đình`.
- Nút đổi ngôn ngữ nằm ngay trên thanh đầu trang.

### 2. Thiết lập vùng an toàn

- Mở từ ô `Thiết lập vùng an toàn` ở trang chủ.
- Dùng `flutter_map` để demo bản đồ.
- Cho phép chọn tâm tọa độ bằng cách chạm lên bản đồ.
- Cho phép nhập tay `vĩ độ` và `kinh độ`.
- Cho phép chỉnh `bán kính` theo mét.
- Khi bấm lưu, mobile gửi `POST` về backend theo route hiện tại của backend.

#### API geofence đang dùng

Route hiện tại:

```text
POST /PKA_ElderGuard/geofences
```

Full URL khi ghép với config mobile:

```text
{API_BASE_URL}/geofences
```

Body:

```json
{
  "device_id": "mobile-123",
  "anchor_latitude": 10.776889,
  "anchor_longitude": 106.700806,
  "radius_meters": 150
}
```

Ghi chú:

- Backend đang dùng `anchor_latitude` và `anchor_longitude`.
- Theo `device_id`, backend sẽ `create` lần đầu và `update` khi gửi lại.

### 3. Giám sát camera demo

- Mỗi camera hiển thị theo 1 hàng.
- Camera hiện là demo UI, không phát video thật.
- Hỗ trợ thêm, đổi tên, xóa camera demo.
- Kéo xuống để refresh lại thứ tự camera theo `id`.
- Mỗi camera có trang chi tiết riêng.
- Card camera cuối không bị che bởi bottom nav bar.

### 4. Cảnh báo push và điều hướng theo camera

- Mobile dùng `OneSignal` kết hợp `flutter_local_notifications`.
- Push được lưu vào inbox local trong app.
- Có popup in-app khi đang mở ứng dụng.
- Có màn hình `Thông báo` để xem danh sách cảnh báo đã nhận.
- Khi backend gửi cảnh báo có `camera_id`, người dùng bấm vào thông báo sẽ mở thẳng trang chi tiết của camera tương ứng.

#### API cảnh báo camera đang dùng

Route hiện tại:

```text
POST /PKA_ElderGuard/events
```

Full URL khi ghép với config mobile:

```text
{API_BASE_URL}/events
```

Body:

```json
{
  "camera_id": 3,
  "timestamp": "2026-04-06T22:10:00",
  "event_type": "fall_detected",
  "confidence": 0.97,
  "url": "demo://camera/3/fall"
}
```

Khi `event_type = "fall_detected"`:

- Backend tạo heading: `Cảnh báo té ngã`
- Backend tạo message: `Phát hiện té ngã tại camera 3`
- Backend gửi kèm dữ liệu push:

```json
{
  "camera_id": 3,
  "event_type": "fall_detected",
  "event_id": 123
}
```

Điều kiện để mobile mở đúng camera:

- Push nên có `camera_id` trong `data`.
- Nếu thiếu `camera_id`, mobile chỉ còn fallback parse từ text kiểu `camera 3`.
- Endpoint `/lost` không có `camera_id`, nên không thể mở thẳng đúng camera.

### 5. Hồ sơ sức khỏe demo

- Có màn hình hồ sơ sức khỏe mô phỏng.
- Dùng để demo bố cục theo dõi người cao tuổi.

## Cấu trúc thư mục đáng chú ý

```text
pka-elder-guard-mobile-app/
+-- README.md
+-- elder_guard_app/
    +-- assets/
    +-- lib/
    |   +-- app/
    |   +-- core/
    |   +-- features/
    |   |   +-- auth/
    |   |   +-- geofence/
    |   |   +-- health_profile/
    |   |   +-- home/
    |   |   +-- menu/
    |   |   +-- monitoring/
    |   |   +-- notifications/
    |   +-- l10n/
    |   +-- main.dart
    +-- l10n.yaml
    +-- pubspec.yaml
```

## Packages chính

- `flutter_riverpod`: state management.
- `http`: gọi backend API.
- `shared_preferences`: lưu local state/session đơn giản.
- `flutter_secure_storage`: lưu dữ liệu nhạy cảm.
- `onesignal_flutter`: nhận push notification.
- `flutter_local_notifications`: hiển thị thông báo hệ thống trong app.
- `flutter_map`: bản đồ demo cho geofence.
- `latlong2`: model tọa độ cho bản đồ.
- `google_fonts`: typography.
- `intl` và `flutter_localizations`: localization.

## Cấu hình backend URL

App hiện lấy base URL từ:

```text
lib/core/config/app_config.dart
```

Biến URL đang dùng ở mobile:

```text
API_BASE_URL
```

Mặc định hiện tại:

```text
https://jeane-unubiquitous-superprecariously.ngrok-free.dev/PKA_ElderGuard
```

Ý nghĩa:

- App hiện mặc định gọi vào public backend.
- Khi backend đổi sang domain public khác, chỉ cần đổi `API_BASE_URL`.

Có thể override khi chạy app:

```bash
flutter run --dart-define=API_BASE_URL=https://your-domain/PKA_ElderGuard
```

Ví dụ chạy với URL public hiện tại:

```bash
flutter run --dart-define=API_BASE_URL=https://jeane-unubiquitous-superprecariously.ngrok-free.dev/PKA_ElderGuard
```

Ví dụ đổi sang domain public khác:

```bash
flutter run --dart-define=API_BASE_URL=https://your-domain/PKA_ElderGuard
```

## Cách chạy app

### Yêu cầu

- Flutter SDK
- Android Studio hoặc Android SDK + ADB
- Thiết bị Android thật hoặc emulator

### Chạy nhanh

```bash
cd elder_guard_app
flutter pub get
flutter gen-l10n
flutter run
```

Nếu muốn chỉ định thiết bị:

```bash
cd elder_guard_app
flutter devices
flutter run -d <device_id>
```

## Lệnh hữu ích

Kiểm tra mã nguồn:

```bash
cd elder_guard_app
flutter analyze
```

Format mã:

```bash
cd elder_guard_app
dart format lib
```

Generate lại localization:

```bash
cd elder_guard_app
flutter gen-l10n
```

Generate launcher icon Android:

```bash
cd elder_guard_app
dart run flutter_launcher_icons
```

## Ghi chú triển khai

- Ứng dụng hiện ưu tiên Android.
- Camera chỉ là demo UI, chưa stream video thật.
- Push alert điều hướng camera đang phụ thuộc vào `camera_id` từ backend.
- OneSignal cần cấu hình backend đầy đủ để push hoạt động end-to-end.
- README này phản ánh trạng thái hiện tại của code trong repo mobile.
