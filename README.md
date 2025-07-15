# pruzi_korak

Pruži Korak APP

## Getting Started

- Rebuild project: dart run build_runner build --delete-conflicting-outputs

### iOS build instructions:
- pod install on mac M1: arch -x86_64 pod install
- build release: flutter build ios lib/main.dart
- build debug: flutter build ios --debug lib/main_dev.dart

### iOS create .ipa:
- create .ipa for release: flutter build ipa --release lib/main.dart

### Android create bundle:
- flutter build appbundle --release lib/main.dart
