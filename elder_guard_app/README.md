# elder_guard_app

Flutter app cho dự án `Elder Guard Mobile App`.

Tài liệu chính của mobile repo nằm tại:

[`../README.md`](../README.md)

## Chạy nhanh

```bash
flutter pub get
flutter gen-l10n
flutter run
```

## Lệnh kiểm tra

```bash
flutter analyze
dart format lib
```

## Ghi chú

- App hiện ưu tiên Android.
- App dùng một biến URL duy nhất là `API_BASE_URL`.
- Mặc định hiện tại:

```bash
https://jeane-unubiquitous-superprecariously.ngrok-free.dev/PKA_ElderGuard
```

- Đổi sang public link bằng:

```bash
flutter run --dart-define=API_BASE_URL=https://your-domain/PKA_ElderGuard
```

- Nếu dùng thiết bị thật thay vì emulator, đổi sang IP LAN hoặc domain public của backend.
