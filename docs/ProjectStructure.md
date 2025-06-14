# 📁 프로젝트 구조

SnapFig의 코드베이스 구조와 각 모듈의 역할을 상세히 설명합니다.

## 🏗️ 전체 구조 개요

SnapFig은 **Clean Architecture**와 **Feature-First** 접근 방식을 채택하여 확장성과 유지보수성을 보장합니다.

```
snapfig/
├── lib/                     # 메인 소스 코드
├── test/                    # 단위/위젯/통합 테스트 코드
├── integration_test/        # 통합 테스트 코드 (Provider 등)
├── assets/                  # 리소스 파일
├── android/                 # Android 플랫폼 코드
├── ios/                     # iOS 플랫폼 코드
├── docs/                    # 프로젝트 문서
```

---

## 📂 lib/ 디렉토리 상세 구조

```
lib/
├── main.dart                # 앱 진입점
├── core/                    # 앱 전체 공통 요소
│   ├── constants/           # 상수 정의
│   ├── theme/               # 테마 및 디자인 시스템
│   └── utils/               # 유틸리티 함수
├── features/                # 기능별 모듈
│   ├── home/                # 홈 화면 및 문서 관리
│   │   ├── models/
│   │   ├── screens/
│   │   └── widgets/
│   ├── pdf_viewer/          # PDF 뷰어 및 관련 기능
│   │   ├── models/
│   │   ├── screens/
│   │   └── widgets/
│   │       └── sidebar/
│   └── settings/            # 설정 화면
├── shared/                  # 공유 서비스 및 위젯
│   ├── services/            # 비즈니스 로직 서비스
│   │   ├── ai_service/
│   │   │   ├── ai_service.dart
│   │   │   ├── ai_service_export.dart
│   │   │   └── models/
│   │   │       └── ai_provider.dart
│   │   ├── ocr_core/
│   │   │   ├── ocr_core.dart
│   │   │   ├── ocr_provider.dart
│   │   │   ├── ocr_provider_impl.dart
│   │   │   └── models/
│   │   │       ├── bounding_box.dart
│   │   │       ├── metadata.dart
│   │   │       ├── ocr_result.dart
│   │   │       └── models.dart
│   │   ├── pdf_core/
│   │   │   ├── pdf_core.dart
│   │   │   ├── models/
│   │   │   │   ├── interface/
│   │   │   │   │   ├── base_pdf.dart
│   │   │   │   │   ├── base_page.dart
│   │   │   │   │   └── base_layout.dart
│   │   │   │   ├── implement/
│   │   │   │   │   ├── pdf_impl.dart
│   │   │   │   │   ├── page_impl.dart
│   │   │   │   │   └── layout_impl.dart
│   │   │   │   └── models.dart
│   │   │   └── provider/
│   │   │       ├── pdf_provider.dart
│   │   │       ├── pdf_provider_impl.dart
│   │   │       └── inherited_pdf_provider_widget.dart
│   │   ├── navigation_service/
│   │   │   ├── navigation_service.dart
│   │   │   └── navigation_view_model.dart
│   │   ├── summarizer_core/
│   │   │   ├── summarizer_core.dart
│   │   │   ├── summarizer_impl.dart
│   │   │   └── summarizer.dart
│   │   ├── ocr_service.dart
│   │   └── pdf_service.dart
│   └── widgets/             # 재사용 가능한 위젯
│       └── document_card.dart
```

---

## 🎯 Core 모듈

앱 전체에서 사용되는 공통 요소들을 관리합니다.

### core/constants/
```
constants/
├── app_constants.dart       # 앱 전체 상수
├── theme_constants.dart     # 테마 관련 상수
```

**주요 역할:**
- 앱 전체에서 사용되는 상수 값 정의
- 하드코딩 방지 및 중앙 관리
- 설정 변경 시 한 곳에서 수정 가능

### core/theme/
```
theme/
├── app_theme.dart          # 메인 테마 설정
├── color_scheme.dart       # 색상 체계
├── text_theme.dart         # 텍스트 스타일
└── theme.dart              # 테마 통합 관리
```

**주요 역할:**
- Material Design 3 기반 테마 시스템
- 다크/라이트 모드 지원
- 일관된 디자인 시스템 제공

---

## 🎨 Features 모듈

각 기능별로 독립적인 모듈로 구성되어 있습니다.

---

## 🔧 Shared 모듈

여러 기능에서 공통으로 사용되는 서비스와 위젯을 관리합니다.

### shared/services/
비즈니스 로직과 외부 서비스 연동을 담당합니다.

#### ai_service/
```
ai_service/
├── ai_service.dart             # AI 서비스 메인 클래스
├── ai_service_export.dart      # AI 서비스 export 파일
└── models/
    └── ai_provider.dart        # AI 프로바이더 모델
```

#### ocr_core/
```
ocr_core/
├── ocr_core.dart              # OCR 서비스 메인 클래스
├── ocr_provider.dart          # OCR API 인터페이스
├── ocr_provider_impl.dart     # OCR API 구현체
└── models/
    ├── bounding_box.dart      # 바운딩 박스 모델
    ├── metadata.dart          # 메타데이터 모델
    ├── ocr_result.dart        # OCR 결과 모델
    └── models.dart            # 모델 통합 export
```

#### pdf_core/
```
pdf_core/
├── pdf_core.dart              # PDF 서비스 메인 클래스
├── models/
│   ├── interface/             # 인터페이스 정의
│   │   ├── base_pdf.dart      # PDF 기본 인터페이스
│   │   ├── base_page.dart     # 페이지 기본 인터페이스
│   │   └── base_layout.dart   # 레이아웃 기본 인터페이스
│   ├── implement/             # 구현체
│   │   ├── pdf_impl.dart      # PDF 구현체
│   │   ├── page_impl.dart     # 페이지 구현체
│   │   └── layout_impl.dart   # 레이아웃 구현체
│   └── models.dart            # 모델 통합 export
└── provider/
    ├── pdf_provider.dart          # PDF 상태 관리 프로바이더
    ├── pdf_provider_impl.dart     # PDF 프로바이더 구현체
    └── inherited_pdf_provider_widget.dart # 상속 위젯
```

#### navigation_service/
```
navigation_service/
├── navigation_service.dart    # 네비게이션 서비스
├── route_generator.dart       # 라우트 생성기
└── app_routes.dart           # 앱 라우트 정의
```

### shared/widgets/
재사용 가능한 공통 위젯들을 관리합니다.

---

## 🧪 Test 구조

테스트 코드는 기능별로 체계적으로 구성되어 있습니다.

```
test/
├── unit/                      # 단위 테스트
│   ├── summarizer_test.dart
│   └── calculator_test.dart
├── widget/                    # 위젯 테스트
│   └── widget_test.dart
└── integration/               # 통합 테스트
    └── auth_test.dart

integration_test/
├── pdf_provider_test.dart
├── ocr_provider_test.dart
└── assets/
```

---

## 📦 Assets 구조

앱에서 사용되는 리소스 파일들을 관리합니다.

```
assets/
├── images/                    # 이미지 리소스
├── icons/                     # 아이콘 이미지
│   ├── nofiles_light.png
│   └── nofiles_dark.png
├── fonts/                     # 폰트 파일
│   ├── Pretendard-SemiBold.ttf
│   └── Pretendard-Medium.ttf
├── sample.pdf                 # 테스트용 PDF
├── sample_ocr_test.pdf        # OCR 테스트용 PDF
└── ocr_result.json            # OCR 결과 샘플
```

---

## 🔄 데이터 흐름

### MVVM 패턴 기반 데이터 흐름

```
View (Widget)
    ↕️
ViewModel (Provider/ChangeNotifier)
    ↕️
Model (Service/Repository)
    ↕️
Data Source (API/Database)
```

### 주요 데이터 흐름 예시

1. **PDF 로딩 흐름**
   ```
   PDFViewerScreen → PDFProvider → PDFService → File System
   ```

2. **OCR 처리 흐름**
   ```
   PDFProvider → OCRService → OCR API → OCRResult
   ```

3. **AI 질의응답 흐름**
   ```
   ChatWidget → AIService → AI Provider → AI API
   ```

---

## 📋 코딩 컨벤션

### 파일 명명 규칙
- **Screen**: `*_screen.dart` (예: `pdf_viewer_screen.dart`)
- **Widget**: `*_widget.dart` 또는 기능명 (예: `pdf_card.dart`)
- **Model**: `*_model.dart` (예: `document_model.dart`)
- **Service**: `*_service.dart` (예: `ai_service.dart`)
- **Provider**: `*_provider.dart` (예: `pdf_provider.dart`)

### 클래스 명명 규칙
- **Screen**: `*Screen` (예: `PDFViewerScreen`)
- **Widget**: `*Widget` 또는 기능명 (예: `PDFCard`)
- **Model**: `*Model` (예: `DocumentModel`)
- **Service**: `*Service` (예: `AIService`)
- **Provider**: `*Provider` (예: `PDFProvider`)

### 디렉토리 구조 원칙
1. **기능별 분리**: 각 기능은 독립적인 폴더로 관리
2. **계층별 분리**: models, screens, widgets로 계층 분리
3. **공통 요소 분리**: shared 폴더에서 재사용 가능한 요소 관리
4. **테스트 구조 일치**: lib 구조와 동일한 test 구조 유지

---

## 🎯 확장 가이드

새로운 기능을 추가할 때 따라야 할 구조:

### 1. 새로운 Feature 추가
```
features/new_feature/
├── models/
├── screens/
└── widgets/
```

### 2. 새로운 Service 추가
```
shared/services/new_service/
├── new_service.dart
├── models/
└── providers/
```

### 3. 테스트 코드 추가
```
test/
├── unit/new_feature/
├── widget/new_feature/
└── integration/new_feature_test.dart
```