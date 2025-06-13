# Snapfig Frontend

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)](https://developer.apple.com/ios/)
[![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com)

> 🎓 대학생을 위한 스마트 PDF 학습 도구

Snapfig는 OCR 기술과 AI를 활용하여 대학생들이 전공서적을 더욱 효율적으로 학습할 수 있도록 지원하는 크로스 플랫폼 모바일 애플리케이션입니다.

## ✨ 주요 기능

### 🔍 OCR 기반 텍스트 추출
- **Figure 및 참조 인식**: 문서 내 Figure와 관련 참조를 자동으로 연결

### 🤖 AI 기반 Figure 분석
- **다중 AI 프로바이더 지원**: OpenAI GPT-4, Google Gemini 연동
- **인터랙티브 Figure 분석**: 터치로 Figure 선택 시 AI 분석 제공
- **실시간 질의응답**: Figure에 대한 질문과 AI 답변

## 🛠️ 기술 스택

### Frontend
- **Framework**: Flutter 3.7.2+
- **Architecture**: MVVM (Model-View-ViewModel)
- **State Management**: ChangeNotifier, InheritedWidget
- **Database**: Isar (NoSQL local database)

### 핵심 의존성
```yaml
dependencies:
  flutter: sdk
  pdfrx: ^1.1.28           # PDF 렌더링
  isar: ^3.1.0+1           # 로컬 데이터베이스
  file_picker: ^10.1.9     # 파일 선택
  http: ^1.4.0             # HTTP 클라이언트
  shared_preferences: ^2.5.3 # 설정 저장
  path_provider: ^2.1.5    # 파일 경로 관리
```

### AI & OCR 연동
- **AI 프로바이더**: OpenAI GPT-4, Google Gemini API
- **OCR 서비스**: 커스텀 OCR API 서버
- **이미지 처리**: Flutter의 dart:ui 라이브러리

## 🚀 시작하기

### 필수 요구사항
- Flutter SDK 3.7.2 이상
- Dart SDK 3.0 이상
- Android Studio / VS Code
- iOS 개발 시 Xcode 필요

### 설치 방법

1. **저장소 클론**
```bash
git clone https://github.com/CommitBang/Frontend.git
cd Frontend
```

2. **의존성 설치**
```bash
flutter pub get
```

3. **코드 생성 (Isar 데이터베이스)**
```bash
flutter packages pub run build_runner build
```

4. **환경 변수 설정**
프로젝트 루트에 `.env` 파일 생성:
```env
OCR_BASE_URL=your_ocr_server_url
```

5. **앱 실행**
```bash
flutter run
```

## ⚙️ 환경 설정

### OCR 서비스 설정
OCR 기능을 사용하려면 백엔드 OCR 서버가 필요합니다:
1. OCR 서버 URL을 `.env` 파일에 설정
2. 서버는 다음 엔드포인트를 제공해야 합니다:
   - `POST /api/v1/analyze`: PDF 분석

### AI 기능 설정
1. 앱 내 설정에서 AI 프로바이더 구성
2. 지원되는 프로바이더:
   - **OpenAI**: API 키 필요 ([platform.openai.com](https://platform.openai.com/api-keys))
   - **Google Gemini**: API 키 필요 ([console.cloud.google.com](https://console.cloud.google.com))

## 📁 프로젝트 구조

```
lib/
├── core/                    # 앱 전체 공통 요소
│   ├── constants/          # 상수 정의
│   └── theme/              # 테마 및 디자인 시스템
├── features/               # 기능별 모듈
│   ├── home/              # 홈 화면 및 문서 관리
│   ├── pdf_viewer/        # PDF 뷰어 및 관련 기능
│   └── settings/          # 설정 화면
└── shared/                # 공유 서비스 및 위젯
    ├── services/          # 비즈니스 로직 서비스
    │   ├── ai_service/    # AI 프로바이더 관리
    │   ├── ocr_core/      # OCR 서비스
    │   ├── pdf_core/      # PDF 데이터 관리
    │   └── navigation_service/ # 내비게이션 관리
    └── widgets/           # 재사용 가능한 위젯
```

### 주요 서비스

- **PDFProvider**: PDF 문서 관리 및 OCR 처리
- **AIService**: AI 프로바이더 통합 관리
- **OCRProvider**: OCR 서버와의 통신
- **NavigationService**: 중앙화된 내비게이션 관리

## 🎯 사용 방법

### 1. PDF 문서 추가
- 홈 화면에서 "새 문서 추가" 버튼 클릭
- 기기에서 PDF 파일 선택
- 자동으로 OCR 처리 시작

### 2. Figure 분석
- PDF 뷰어에서 Figure 영역 터치
- "Ask AI" 버튼으로 AI 분석 요청
- 드래그 가능한 채팅 창에서 질의응답

### 3. 문서 관리
- 최근 문서에서 빠른 접근
- 문서 이름 변경 및 삭제
- 읽던 페이지 자동 저장

## 🧪 테스트

### 단위 테스트 실행
```bash
flutter test
```

### 통합 테스트 실행
```bash
flutter test integration_test/
```

## 🤝 기여하기
1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### 개발 가이드라인
- XP(eXtreme Programming) 방법론 준수
- 페어 프로그래밍 권장
- 테스트 주도 개발(TDD) 실천
- 코드 리뷰 필수

### 브랜치 전략
- `main`: 프로덕션 브랜치
- `develop`: 개발 브랜치  
- `feature/*`: 새로운 기능 개발
- `bugfix/*`: 버그 수정
- `hotfix/*`: 긴급 수정

### 커밋 메시지 규칙

| 타입       | 설명        | 예시                     |
|----------|-----------|------------------------|
| feat     | 새로운 기능 추가 | feat: 로그인 기능 구현        |
| fix      | 버그 수정     | fix: 로그인 시 토큰 만료 오류 수정 |
| docs     | 문서 수정     | docs: README 업데이트      |
| style    | 코드 포맷팅    | style: 코드 들여쓰기 수정      |
| refactor | 코드 리팩토링   | refactor: 로그인 로직 개선    |
| test     | 테스트 코드    | test: 로그인 테스트 케이스 추가   |
| chore    | 빌드 업무 수정  | chore: 패키지 버전 업데이트     |

#### 커밋 메시지 형식

```
<타입>: <설명>
[선택사항: 본문]
```

## 📄 라이선스

이 프로젝트는 APACH 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.