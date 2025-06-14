# 🚀 시작하기 가이드

SnapFig을 설치하고 실행하는 상세한 가이드입니다.

## 📋 필수 요구사항

### 개발 환경
- **Flutter SDK**: 3.7.2 이상
- **Dart SDK**: 3.0 이상
- **IDE**: Android Studio, VS Code, 또는 IntelliJ IDEA
- **Git**: 버전 관리를 위해 필요

### 플랫폼별 요구사항

#### Android 개발
- **Android Studio**: 최신 버전 권장
- **Android SDK**: API 레벨 25 (Android 7.1) 이상

#### iOS 개발 (macOS만 해당)
- **Xcode**: 14.0 이상
- **iOS Deployment Target**: iOS 12.0 이상
- **CocoaPods**: 의존성 관리를 위해 필요

---

## 🛠️ 설치 과정

### 1. Flutter 설치

#### macOS
```bash
# Homebrew를 사용한 설치
brew install flutter

# 또는 공식 사이트에서 다운로드
# https://docs.flutter.dev/get-started/install/macos
```

#### Windows
```bash
# Chocolatey를 사용한 설치
choco install flutter

# 또는 공식 사이트에서 다운로드
# https://docs.flutter.dev/get-started/install/windows
```

#### Linux
```bash
# Snap을 사용한 설치
sudo snap install flutter --classic

# 또는 공식 사이트에서 다운로드
# https://docs.flutter.dev/get-started/install/linux
```

### 2. Flutter 설정 확인

```bash
# Flutter 설치 상태 확인
flutter doctor

# 누락된 의존성이 있다면 안내에 따라 설치
```

### 3. 프로젝트 클론 및 설정

```bash
# 저장소 클론
git clone https://github.com/CommitBang/Frontend.git
cd Frontend

# 의존성 설치
flutter pub get

# 코드 생성 (Isar 데이터베이스용)
flutter packages pub run build_runner build
```

---

## ⚙️ 환경 설정

### OCR 서비스 설정

SnapFig의 OCR 기능을 사용하려면 백엔드 OCR 서버가 필요합니다.

1. **환경 변수 파일 생성**
   프로젝트 루트에 `.env` 파일을 생성하고 다음 내용을 추가:

```env
# OCR 서버 설정
OCR_BASE_URL=http://your-ocr-server.com
```

2. **OCR 서버 요구사항**
   OCR 서버는 다음 엔드포인트를 제공해야 합니다:
   - `POST /api/v1/analyze`: PDF 분석 및 Figure 추출

   > 📖 **OCR 서버 구축**: [PDFRecognitionAPI](https://github.com/CommitBang/PDFRecognitionAPI) 참조

### AI 기능 설정

AI 기능은 앱 내에서 설정할 수 있습니다.

#### OpenAI 설정
1. [OpenAI Platform](https://platform.openai.com/api-keys)에서 API 키 발급
2. 앱 실행 후 설정 화면에서 API 키 입력
3. 모델 선택 (GPT-4 권장)

#### Google Gemini 설정
1. [Google Cloud Console](https://console.cloud.google.com)에서 API 키 발급
2. Gemini API 활성화
3. 앱 설정에서 API 키 입력

---

## 🏃‍♂️ 앱 실행

### 개발 모드 실행

```bash
# 연결된 기기 확인
flutter devices

# 앱 실행 (기본 기기)
flutter run

# 특정 기기에서 실행
flutter run -d <device_id>

# 디버그 모드로 실행
flutter run --debug

# 릴리즈 모드로 실행
flutter run --release
```

### 플랫폼별 실행

#### Android
```bash
# Android 에뮬레이터 실행
flutter emulators --launch <emulator_id>

# Android 기기에서 실행
flutter run -d android
```

#### iOS (macOS만 해당)
```bash
# iOS 시뮬레이터 실행
open -a Simulator

# iOS 기기에서 실행
flutter run -d ios
```

---

## 🔧 개발 도구 설정

### VS Code 확장 프로그램
- **Flutter**: Flutter 개발 지원
- **Dart**: Dart 언어 지원
- **Flutter Widget Snippets**: 위젯 스니펫
- **Awesome Flutter Snippets**: 추가 스니펫

### Android Studio 플러그인
- **Flutter Plugin**: Flutter 개발 지원
- **Dart Plugin**: Dart 언어 지원

---

## 🧪 테스트 실행

### 단위 테스트
```bash
# 모든 테스트 실행
flutter test

# 특정 테스트 파일 실행
flutter test test/unit/pdf_service_test.dart

# 커버리지 포함 테스트
flutter test --coverage
```

### 통합 테스트
```bash
# 통합 테스트 실행
flutter test integration_test/

# 특정 통합 테스트
flutter test integration_test/app_test.dart
```

---

## 📱 빌드 및 배포

### Android APK 빌드
```bash
# 디버그 APK 빌드
flutter build apk --debug

# 릴리즈 APK 빌드
flutter build apk --release

# App Bundle 빌드 (Google Play Store용)
flutter build appbundle --release
```

### iOS 빌드 (macOS만 해당)
```bash
# iOS 앱 빌드
flutter build ios --release

# Xcode에서 빌드
open ios/Runner.xcworkspace
```

---

## 🐛 문제 해결

### 일반적인 문제들

#### 1. Flutter Doctor 오류
```bash
# Flutter 설치 상태 재확인
flutter doctor -v

# Flutter 업그레이드
flutter upgrade
```

#### 2. 의존성 문제
```bash
# 의존성 재설치
flutter clean
flutter pub get
```

#### 3. 코드 생성 오류
```bash
# 빌드 러너 재실행
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

#### 4. iOS 빌드 오류
```bash
# CocoaPods 재설치
cd ios
pod deintegrate
pod install
cd ..
```

---

## 📞 추가 도움

문제가 지속되면 다음 리소스를 참조하세요:

- **Flutter 공식 문서**: [flutter.dev](https://flutter.dev)
- **프로젝트 이슈**: [GitHub Issues](https://github.com/CommitBang/Frontend/issues)
- **Flutter 커뮤니티**: [Flutter Discord](https://discord.gg/flutter)

---

## 🎯 다음 단계

설치가 완료되었다면:

1. **[프로젝트 구조](ProjectStructure.md)** 문서로 코드베이스 이해하기
2. **[기여 가이드](Contributing.md)** 문서로 개발 프로세스 학습하기
3. **[브랜치 전략](Branching.md)** 문서로 Git 워크플로우 파악하기 