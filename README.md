# Snapfig Frontend

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)](https://developer.apple.com/ios/)
[![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com)
[![Tests](https://img.shields.io/badge/Tests-Passing-brightgreen?style=for-the-badge)](https://github.com/CommitBang/Frontend/actions)
[![Coverage](https://img.shields.io/badge/Coverage-85%25-brightgreen?style=for-the-badge)](https://github.com/CommitBang/Frontend/actions)

## 📖 프로젝트 소개

SnapFig은 대학생들이 전공 서적을 보다 효율적으로 학습할 수 있도록 돕는 크로스플랫폼 모바일 애플리케이션입니다.  
OCR 기반 텍스트 추출, PDF 문서 구조 자동 분석, 주석–Figure 매핑 & 팝업 기능을 제공하여  
사용자가 중요한 내용과 그림을 빠르게 찾아보고 관리할 수 있게 합니다.

---

## 목차

- [주요 기능](#-주요-기능)
- [기술 스택](#-기술-스택)
- [설치 및 실행](#-설치-및-실행)
- [프로젝트 구조](#프로젝트-구조)
    - [주요 디렉토리 설명](#주요-디렉토리-설명)
- [팀원 구성](#-팀원-구성)
- [프로젝트 계획서](#-프로젝트-계획서)
- [Branch 전략](#branch-전략)
    - [브랜치 구조](#브랜치-구조)
    - [작업 흐름](#작업-흐름)
    - [커밋 메시지 규칙](#커밋-메시지-규칙)
- [기여 방법](#-기여-방법)
- [라이선스](#-라이선스)

---

## 🚀 주요 기능

- **OCR 기반 텍스트 추출**  
  스캔된 PDF에서도 텍스트를 정확히 인식하여 디지털 텍스트로 변환
- **챕터 자동 인식 & 목차 생성**  
  문서 구조를 분석해 자동으로 목차를 구성하고 챕터별 이동 지원
- **주석–Figure 자동 매핑 & 팝업**  
  본문 주석을 탭하면 관련 Figure 팝업으로 즉시 확인
- **학습 관리**  
  즐겨찾기, 하이라이트, 메모 기능으로 중요 내용을 저장·관리

---

## 🛠 기술 스택

- **Flutter & Dart**
- **PDF 처리**: pdfrx
- **파일 선택**: file_picker
- **경로 관리**: path
- **수학 연산**: vector_math
- **상태 관리**: Provider 패턴
- **CI/CD**: GitHub Actions

---

## 📱 설치 및 실행

```bash
# 1. 저장소 클론
git clone https://github.com/CommitBang/Frontend.git
cd Frontend

# 2. Flutter 패키지 설치
flutter pub get

# 3. 앱 실행
flutter run
```

## 프로젝트 구조

```

lib/
├── core/
│ ├── constants/
│ │ ├── app_constants.dart
│ │ └── theme_constants.dart
│ └── theme/
│ ├── app_theme.dart
│ ├── color_scheme.dart
│ ├── text_theme.dart
│ └── theme.dart
│
├── features/
│ ├── home/
│ │ ├── screens/
│ │ │ ├── documents_widget.dart
│ │ │ ├── home_widget.dart
│ │ │ └── recent_widget.dart
│ │ └── widgets/
│ │ ├── add_document_button.dart
│ │ ├── empty_files_icon.dart
│ │ ├── home_components.dart
│ │ ├── pdf_card.dart
│ │ ├── pdf_list_item.dart
│ │ └── show_rename_dialog.dart
│ │
│ └── pdf_viewer/
│ ├── models/
│ │ ├── figure_info.dart
│ │ ├── ocr_text_block.dart
│ │ ├── pdf_document_model.dart ← 이동됨
│ │ ├── pdf_layout_model.dart ← 이동됨
│ │ └── pdf_page_model.dart ← 이동됨
│ ├── screens/
│ │ └── pdf_viewer_screen.dart
│ └── widgets/
│ ├── figure_list_panel.dart
│ ├── ocr_overlay_painter.dart
│ └── pdf_page_viewer.dart
│
├── shared/
│ ├── services/
│ │ ├── ocr_core/
│ │ │ ├── ocr_core.dart
│ │ │ ├── ocr_provider.dart
│ │ │ └── ocr_result.dart
│ │ │
│ │ ├── pdf_core/
│ │ │ ├── models/
│ │ │ │ ├── implement/
│ │ │ │ │ ├── layout_impl.dart
│ │ │ │ │ ├── layout_impl.g.dart
│ │ │ │ │ ├── page_impl.dart
│ │ │ │ │ ├── page_impl.g.dart
│ │ │ │ │ ├── pdf_impl.dart
│ │ │ │ │ └── pdf_impl.g.dart
│ │ │ │ ├── interface/
│ │ │ │ │ ├── base_layout.dart
│ │ │ │ │ ├── base_page.dart
│ │ │ │ │ └── base_pdf.dart
│ │ │ │ └── models.dart
│ │ │ ├── provider/
│ │ │ │ ├── inherited_pdf_provider_widget.dart
│ │ │ │ ├── pdf_provider.dart
│ │ │ │ └── pdf_provider_impl.dart
│ │ │ └── pdf_core.dart
│ │ │
│ │ ├── ocr_service.dart
│ │ └── pdf_service.dart
│ │
│ └── widgets/
│ └── document_card.dart
│
└── main.dart

test/
├── unit/
├── widget/
└── integration/

assets/
├── images/
├── fonts/
├── icons/
└── sample.pdf/

```

### 주요 디렉토리 설명

| 디렉토리          | 하위 디렉토리                | 설명                     |
|---------------|------------------------|------------------------|
| **core/**     | constants/             | 앱 전체에서 사용되는 상수 정의      |
|               | theme/                 | 앱의 디자인 시스템 및 테마 관련 코드  |
|               | utils/                 | 재사용 가능한 유틸리티 함수들       |
| **features/** | auth/, home/, profile/ | 각 기능별로 독립적인 모듈 구성      |
|               | */screens/             | 각 기능의 화면 구현            |
|               | */widgets/             | 각 기능의 위젯 구현            |
|               | */models/              | 각 기능의 데이터 모델           |
| **shared/**   | widgets/               | 여러 기능에서 공통으로 사용되는 컴포넌트 |
|               | services/              | 재사용 가능한 서비스            |
| **test/**     | unit/                  | 단위 테스트                 |
|               | widget/                | 위젯 테스트                 |
|               | integration/           | 통합 테스트                 |
| **assets/**   | images/                | 이미지 리소스                |
|               | fonts/                 | 폰트 파일                  |
|               | icons/                 | 아이콘 리소스                |

## 👥 팀원 구성

| 이름  | 역할                            | 주요 기술 스택                    |
|-----|-------------------------------|-----------------------------|
| 박철오 | QA 및 리뷰어, Back-end            | Python, Java, Data Science  |
| 차현준 | 문서 담당자, Back-end              | Java, Python, Spring Boot   |
| 이주환 | 문서 담당자, Front-end             | Flutter, Dart, pdfrx        |
| 이재호 | 프로젝트 매니저, QA 및 리뷰어, Front-end | iOS, SwiftUI, C++, Embedded |

## 📄 프로젝트 계획서

### 1. 프로젝트 개요 및 목적

- **목적**: 전공 서적의 복잡한 PDF 문서에서 핵심 텍스트·Figure를 자동 추출하여  
  빠르고 효율적인 학습 경험 제공

### 2. 주요 산출물

- 크로스플랫폼 Flutter 앱
- 반응형 UI/UX 디자인
- 주석–Figure 매핑 알고리즘 및 팝업 UI
- 챕터 구조 자동 인식 및 목차 생성 모듈
- OCR 엔진 통합 및 텍스트 기반 설명 생성 API

### 3. 조직 구조

| 이름  | 역할                            | 기술 스택                       |
|-----|-------------------------------|-----------------------------|
| 이재호 | 프로젝트 매니저, QA 및 리뷰어, Front-end | C++, Embedded, SwiftUI, iOS |
| 박철오 | QA 및 리뷰어, Back-end            | Data Science, Java, Python  |
| 차현준 | 문서 담당자, Back-end              | Java, Python, Spring Boot   |
| 이주환 | 문서 담당자, Front-end             | Flutter, Java, Python       |

### 4. 일정 및 WBS 요약

| 단계         | 기간                 | 주요 작업                              |
|------------|--------------------|------------------------------------|
| 요구사항 분석    | 2025-04-29 ~ 05-04 | 기능 요구사항 정의 및 문서화                   |
| 시스템 설계     | 2025-05-05 ~ 05-09 | API 설계, DB 스키마 설계, UI 플로우 차트 작성    |
| 개발 (백엔드)   | 2025-05-03 ~ 05-09 | OCR 모듈, 챕터 인식, 텍스트 처리 API 개발       |
| 개발 (프론트엔드) | 2025-05-07 ~ 05-19 | Flutter 앱 초기 구조, PDF 뷰어 & 팝업 UI 구현 |
| 통합 및 테스트   | 2025-05-20 ~ 05-25 | 단위/통합 테스트, 디바이스 테스트                |
| 배포 및 문서화   | 2025-05-24 ~ 05-28 | 앱 스토어 패키징, 사용자 매뉴얼 작성              

## Branch 전략

### 브랜치 구조

- `main`: 프로덕션 브랜치
- `develop`: 개발 브랜치
- `feature/*`: 새로운 기능 개발 브랜치 (기능명)
- `bugfix/*`: 버그 수정 브랜치 (버그명)
- `hotfix/*`: 프로덕션 환경의 긴급 수정 브랜치 (수정명)

### 작업 흐름

1. `develop` 브랜치에서 새로운 브랜치 생성
2. 개발/수정 작업 진행
3. 작업 완료 후 Pull Request 생성
4. 코드 리뷰 후 `develop` 브랜치로 병합
5. `develop` 브랜치의 안정성이 확인되면 `main` 브랜치로 병합
6. 병합 후 브랜치 삭제

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

## 🤝 기여 방법

1. **Fork & Clone** 저장소
2. **브랜치 네이밍**: `feature/*`, `bugfix/*`
3. **커밋 메시지**: `type(scope): 설명`
4. **PR 전 확인**:

- [CONTRIBUTING.md](./CONTRIBUTING.md)
- `.github/ISSUE_TEMPLATE/` 템플릿 사용

5. **리뷰 프로세스**: 최소 두 명의 리뷰어 승인 후 Merge  