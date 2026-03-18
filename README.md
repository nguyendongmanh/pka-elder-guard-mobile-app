# Elder Guard Mobile App

Ứng dụng di động `Elder Guard` đang được phát triển bằng Flutter. Hiện tại dự án ưu tiên Android, đã có cấu hình tên app, icon app, asset logo và nền tảng localization để tiếp tục mở rộng các màn hình chức năng.

## Trạng thái hiện tại

- Đã khởi tạo project Flutter trong thư mục `elder_guard_app`.
- Đã cấu hình app name trên Android là `Elder Guard`.
- Đã cấu hình launcher icon Android từ logo trong `assets/elderguard_logoapp.png`.
- Đã thêm hệ thống localization với 2 ngôn ngữ `en` và `vi`.
- Đã generate file localization từ `l10n.yaml`.
- Đã khai báo asset trong `pubspec.yaml`.
- Đã cài sẵn một số thư viện nền để phục vụ các bước phát triển tiếp theo như `flutter_riverpod`, `go_router`, `shared_preferences`, `shimmer`.

## Công cụ và thư viện sử dụng

### Nền tảng chính

- `Flutter`: framework phát triển ứng dụng đa nền tảng.
- `Dart`: ngôn ngữ lập trình chính của dự án.
- `Android`: nền tảng mục tiêu hiện tại.

### Packages đã có trong dự án

- `flutter_localizations`: hỗ trợ đa ngôn ngữ cho ứng dụng Flutter.
- `intl`: phục vụ localization và xử lý chuỗi theo ngôn ngữ.
- `flutter_riverpod`: thư viện quản lý state đã được thêm sẵn để dùng cho các màn tiếp theo.
- `go_router`: thư viện điều hướng.
- `shared_preferences`: lưu trữ local đơn giản trên thiết bị.
- `shimmer`: hỗ trợ hiển thị loading skeleton.
- `flutter_launcher_icons`: dùng để generate app icon Android.
- `flutter_lints`: bộ lint để giữ code nhất quán và sạch hơn.

## Cấu trúc đáng chú ý

```text
pka-elder-guard-mobile-app/
+-- README.md
+-- elder_guard_app/
    +-- assets/
    +-- android/
    +-- lib/
    |   +-- l10n/
    |   +-- main.dart
    +-- l10n.yaml
    +-- pubspec.yaml
```

## Cách chạy app

### Yêu cầu môi trường

- Cài `Flutter SDK`.
- Có `Android Studio` hoặc Android SDK/ADB để chạy emulator hay thiết bị thật.
- Máy cần nhận được thiết bị Android qua `flutter devices`.

### Các bước chạy

Từ thư mục gốc của repo:

```bash
cd elder_guard_app
flutter pub get
flutter run
```

Nếu muốn chỉ định thiết bị Android cụ thể:

```bash
cd elder_guard_app
flutter devices
flutter run -d <device_id>
```

## Các lệnh hữu ích

Generate lại localization:

```bash
cd elder_guard_app
flutter gen-l10n
```

Generate lại app icon Android sau khi thay logo:

```bash
cd elder_guard_app
dart run flutter_launcher_icons
```

Kiểm tra nhanh chất lượng mã nguồn:

```bash
cd elder_guard_app
flutter analyze
```

## Ghi chú

- Dự án hiện mới tập trung cho Android.
- `flutter_riverpod` đã được thêm vào dependency nhưng chưa triển khai luồng state management cụ thể trong `lib/main.dart`.
- Màn hình hiện tại vẫn là màn hình khởi tạo cơ bản, phù hợp để tiếp tục phát triển tính năng thực tế ở các bước sau.
