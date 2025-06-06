# Snapfig Frontend

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)](https://developer.apple.com/ios/)
[![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com)
[![Tests](https://img.shields.io/badge/Tests-Passing-brightgreen?style=for-the-badge)](https://github.com/CommitBang/Frontend/actions)
[![Coverage](https://img.shields.io/badge/Coverage-85%25-brightgreen?style=for-the-badge)](https://github.com/CommitBang/Frontend/actions)

## 목차

- [프로젝트 구조](#프로젝트-구조)
    - [주요 디렉토리 설명](#주요-디렉토리-설명)
- [Branch 전략](#branch-전략)
    - [브랜치 구조](#브랜치-구조)
    - [작업 흐름](#작업-흐름)
    - [커밋 메시지 규칙](#커밋-메시지-규칙)

## 프로젝트 구조

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── theme_constants.dart
│   └── theme/
│       ├── app_theme.dart
│       ├── color_scheme.dart
│       ├── text_theme.dart
│       └── theme.dart
│
├── features/
│   ├── home/
│   │   ├── screens/
│   │   │   ├── documents_widget.dart
│   │   │   ├── home_widget.dart
│   │   │   └── recent_widget.dart
│   │   └── widgets/
│   │       ├── add_document_button.dart
│   │       ├── empty_files_icon.dart
│   │       ├── home_components.dart
│   │       ├── pdf_card.dart
│   │       ├── pdf_list_item.dart
│   │       └── show_rename_dialog.dart
│   │
│   └── pdf_viewer/
│       ├── models/
│       │   ├── figure_info.dart
│       │   ├──  ocr_text_block.dart
│       │   ├── pdf_document_model.dart    ← 이동됨
│       │   ├── pdf_layout_model.dart      ← 이동됨
│       │   └── pdf_page_model.dart        ← 이동됨
│       ├── screens/
│       │   └── pdf_viewer_screen.dart
│       └── widgets/
│           ├── figure_list_panel.dart
│           ├── ocr_overlay_painter.dart
│           └── pdf_page_viewer.dart
│
├── shared/
│   ├── services/
│   │   ├── ocr_core/
│   │   │   ├── ocr_core.dart
│   │   │   ├── ocr_provider.dart
│   │   │   └── ocr_result.dart
│   │   │
│   │   ├── pdf_core/
│   │   │   ├── models/
│   │   │   │   ├── implement/
│   │   │   │   │   ├── layout_impl.dart
│   │   │   │   │   ├── layout_impl.g.dart
│   │   │   │   │   ├── page_impl.dart
│   │   │   │   │   ├── page_impl.g.dart
│   │   │   │   │   ├── pdf_impl.dart
│   │   │   │   │   └── pdf_impl.g.dart
│   │   │   │   ├── interface/
│   │   │   │   │   ├── base_layout.dart
│   │   │   │   │   ├── base_page.dart
│   │   │   │   │   └── base_pdf.dart
│   │   │   │   └── models.dart
│   │   │   ├── provider/
│   │   │   │   ├── inherited_pdf_provider_widget.dart
│   │   │   │   ├── pdf_provider.dart
│   │   │   │   └── pdf_provider_impl.dart
│   │   │   └── pdf_core.dart
│   │   │
│   │   ├── ocr_service.dart
│   │   └── pdf_service.dart
│   │
│   └── widgets/
│       └── document_card.dart
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