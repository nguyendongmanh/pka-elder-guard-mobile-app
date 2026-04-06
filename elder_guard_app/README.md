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
- Base URL backend có thể override bằng:

```bash
flutter run --dart-define=API_BASE_URL=https://your-domain/PKA_ElderGuard
```
