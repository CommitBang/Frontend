# 🤝 기여 가이드

SnapFig 프로젝트에 기여해주셔서 감사합니다! 이 문서는 프로젝트에 효과적으로 기여하는 방법을 안내합니다.

## 🎯 기여 방법 개요

SnapFig은 오픈소스 프로젝트로, 다양한 형태의 기여를 환영합니다:

- 🐛 **버그 리포트**: 발견한 문제점 신고
- 💡 **기능 제안**: 새로운 기능 아이디어 제안
- 📝 **코드 기여**: 버그 수정, 기능 구현, 성능 개선
- 📚 **문서 개선**: README, 가이드, 주석 개선
- 🧪 **테스트 추가**: 테스트 커버리지 향상
- 🎨 **UI/UX 개선**: 사용자 경험 향상

---

## 🚀 시작하기

### 1. 개발 환경 설정

기여를 시작하기 전에 개발 환경을 설정해주세요:

```bash
# 1. 저장소 Fork 후 클론
git clone https://github.com/YOUR_USERNAME/Frontend.git
cd Frontend

# 2. 원본 저장소를 upstream으로 추가
git remote add upstream https://github.com/CommitBang/Frontend.git

# 3. 의존성 설치
flutter pub get

# 4. 코드 생성
flutter packages pub run build_runner build

# 5. 테스트 실행하여 환경 확인
flutter test
```

### 2. 이슈 확인

기여하기 전에 다음을 확인해주세요:

- **기존 이슈 검색**: 동일한 문제나 제안이 있는지 확인
- **라벨 확인**: `good first issue`, `help wanted` 라벨 확인
- **할당 상태**: 이미 누군가 작업 중인지 확인

---

## 🐛 버그 리포트

버그를 발견했다면 다음 정보를 포함하여 이슈를 생성해주세요:

### 버그 리포트 템플릿

```markdown
## 🐛 버그 설명
버그에 대한 명확하고 간결한 설명

## 🔄 재현 단계
1. '...'로 이동
2. '...'를 클릭
3. '...'까지 스크롤
4. 오류 발생

## 🎯 예상 동작
예상했던 동작에 대한 설명

## 📱 실제 동작
실제로 발생한 동작에 대한 설명

## 📸 스크린샷
가능하다면 스크린샷 첨부

## 🔧 환경 정보
- OS: [예: iOS 16.0, Android 13]
- 기기: [예: iPhone 14, Samsung Galaxy S23]
- Flutter 버전: [예: 3.7.2]
- 앱 버전: [예: 1.0.0]

## 📝 추가 정보
기타 관련 정보나 컨텍스트
```

---

## 💡 기능 제안

새로운 기능을 제안할 때는 다음 정보를 포함해주세요:

### 기능 제안 템플릿

```markdown
## 🚀 기능 설명
제안하는 기능에 대한 명확한 설명

## 🎯 문제점
이 기능이 해결하고자 하는 문제

## 💡 해결 방안
제안하는 해결 방안에 대한 설명

## 🔄 대안
고려해본 다른 대안들

## 📝 추가 정보
기타 관련 정보나 컨텍스트
```

---

## 📝 코드 기여

### 1. 브랜치 생성

작업을 시작하기 전에 적절한 브랜치를 생성해주세요:

```bash
# 최신 코드로 업데이트
git checkout main
git pull upstream main

# 새 브랜치 생성
git checkout -b feature/amazing-feature
# 또는
git checkout -b bugfix/fix-critical-bug
```

### 2. 코딩 스타일

SnapFig은 다음 코딩 스타일을 따릅니다:

#### Dart 코딩 컨벤션
- **공식 Dart 스타일 가이드** 준수
- **dartfmt**를 사용한 자동 포맷팅
- **dart analyze**를 통한 정적 분석 통과

```bash
# 코드 포맷팅
dart format .

# 정적 분석
dart analyze
```

#### 네이밍 컨벤션
```dart
// 클래스: PascalCase
class PDFViewerScreen extends StatefulWidget {}

// 변수, 함수: camelCase
String documentTitle = '';
void loadDocument() {}

// 상수: lowerCamelCase
const String apiBaseUrl = 'https://api.example.com';

// 파일명: snake_case
pdf_viewer_screen.dart
document_model.dart
```

#### 주석 작성
```dart
/// PDF 문서를 로드하고 OCR 처리를 수행합니다.
/// 
/// [filePath]는 로드할 PDF 파일의 경로입니다.
/// [enableOCR]이 true이면 OCR 처리를 함께 수행합니다.
/// 
/// Returns: 로드된 PDF 문서 정보
/// Throws: [FileNotFoundException] 파일을 찾을 수 없는 경우
Future<PDFDocument> loadDocument(
  String filePath, {
  bool enableOCR = true,
}) async {
  // 구현 내용
}
```

### 3. 테스트 작성

모든 새로운 기능과 버그 수정에는 적절한 테스트가 포함되어야 합니다:

#### 단위 테스트
```dart
// test/unit/services/pdf_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:snapfig/shared/services/pdf_service.dart';

void main() {
  group('PDFService', () {
    late PDFService pdfService;

    setUp(() {
      pdfService = PDFService();
    });

    test('should load PDF document successfully', () async {
      // Given
      const filePath = 'assets/sample/test.pdf';

      // When
      final result = await pdfService.loadDocument(filePath);

      // Then
      expect(result, isNotNull);
      expect(result.pageCount, greaterThan(0));
    });
  });
}
```

#### 위젯 테스트
```dart
// test/widget/home/pdf_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snapfig/features/home/widgets/pdf_card.dart';

void main() {
  testWidgets('PDFCard should display document title', (tester) async {
    // Given
    const documentTitle = 'Test Document';

    // When
    await tester.pumpWidget(
      MaterialApp(
        home: PDFCard(title: documentTitle),
      ),
    );

    // Then
    expect(find.text(documentTitle), findsOneWidget);
  });
}
```

### 4. 커밋 메시지

의미 있는 커밋 메시지를 작성해주세요:

#### 커밋 메시지 형식
```
<타입>(<범위>): <설명>

<본문>

<푸터>
```

#### 타입
- `feat`: 새로운 기능 추가
- `fix`: 버그 수정
- `docs`: 문서 수정
- `style`: 코드 포맷팅, 세미콜론 누락 등
- `refactor`: 코드 리팩토링
- `test`: 테스트 추가 또는 수정
- `chore`: 빌드 프로세스 또는 보조 도구 변경

#### 예시
```bash
feat(pdf-viewer): Add figure highlighting functionality

- Implement OCR-based figure detection
- Add visual highlighting for selected figures
- Integrate with AI service for figure analysis

Closes #123
```

### 5. Pull Request 생성

작업이 완료되면 Pull Request를 생성해주세요:

#### PR 체크리스트
- [ ] 코드가 프로젝트 스타일 가이드를 따름
- [ ] 새로운 기능에 대한 테스트 추가
- [ ] 모든 테스트가 통과
- [ ] 문서 업데이트 (필요한 경우)
- [ ] 변경사항에 대한 명확한 설명

#### PR 템플릿
```markdown
## 📝 변경사항 설명
이 PR에서 변경된 내용에 대한 설명

## 🔗 관련 이슈
Closes #123

## 🧪 테스트
- [ ] 단위 테스트 추가/수정
- [ ] 위젯 테스트 추가/수정
- [ ] 통합 테스트 추가/수정
- [ ] 수동 테스트 완료

## 📸 스크린샷 (UI 변경사항이 있는 경우)
변경 전후 스크린샷

## 📋 체크리스트
- [ ] 코드 스타일 가이드 준수
- [ ] 테스트 추가/수정
- [ ] 문서 업데이트
- [ ] 브레이킹 체인지 없음 (있다면 설명)
```

---

## 🔍 코드 리뷰

### 리뷰 프로세스

1. **자동 검사**: CI/CD 파이프라인에서 자동 테스트 실행
2. **코드 리뷰**: 최소 2명의 리뷰어가 코드 검토
3. **피드백 반영**: 리뷰 의견에 따른 수정
4. **승인 및 머지**: 모든 검토 완료 후 메인 브랜치에 병합

### 리뷰 기준

- **기능성**: 코드가 의도한 대로 동작하는가?
- **가독성**: 코드가 이해하기 쉬운가?
- **성능**: 성능에 부정적인 영향은 없는가?
- **테스트**: 적절한 테스트가 포함되어 있는가?
- **문서**: 필요한 문서가 업데이트되었는가?

---

## 📚 문서 기여

문서 개선도 중요한 기여입니다:

### 문서 유형
- **README**: 프로젝트 소개 및 시작 가이드
- **API 문서**: 코드 주석 및 API 설명
- **사용자 가이드**: 앱 사용법 안내
- **개발자 가이드**: 개발 관련 문서

### 문서 작성 가이드
- **명확성**: 이해하기 쉬운 언어 사용
- **완전성**: 필요한 모든 정보 포함
- **최신성**: 코드 변경사항과 동기화
- **예시**: 구체적인 예시 코드 포함

---

## 🎨 UI/UX 기여

디자인 개선에 기여하고 싶다면:

### 디자인 가이드라인
- **Material Design 3** 준수
- **접근성** 고려 (색상 대비, 폰트 크기 등)
- **일관성** 유지
- **사용성** 우선

### 디자인 제안 방법
1. **Figma** 또는 **Adobe XD**로 목업 제작
2. **이슈**에 디자인 첨부하여 제안
3. **피드백** 수렴 후 구현

---

## 🏆 기여자 인정

모든 기여자는 다음과 같이 인정받습니다:

- **README**의 기여자 섹션에 이름 추가
- **릴리즈 노트**에 기여 내용 명시
- **GitHub 프로필**에 기여 배지 표시

---

## 📞 도움 요청

기여 과정에서 도움이 필요하다면:

- **GitHub Issues**: 기술적 질문
- **GitHub Discussions**: 일반적인 토론
- **Discord**: 실시간 채팅 (링크 추후 제공)

---

## 📋 자주 묻는 질문

### Q: 처음 기여하는데 어떤 이슈부터 시작하면 좋을까요?
A: `good first issue` 라벨이 붙은 이슈부터 시작하는 것을 추천합니다.

### Q: 코드 스타일을 자동으로 확인할 수 있나요?
A: 네, `dart format .`과 `dart analyze` 명령어를 사용하세요.

### Q: 테스트는 어떻게 작성해야 하나요?
A: 기존 테스트 파일을 참고하여 유사한 패턴으로 작성해주세요.

### Q: PR이 머지되기까지 얼마나 걸리나요?
A: 일반적으로 1-2주 정도 소요되며, 복잡도에 따라 달라질 수 있습니다.

---

## 🎯 다음 단계

기여 가이드를 읽었다면:

1. **[브랜치 전략](Branching.md)** 문서로 Git 워크플로우 학습
2. **[프로젝트 구조](ProjectStructure.md)** 문서로 코드베이스 이해
3. **첫 번째 이슈** 선택하여 기여 시작!

---

**SnapFig 프로젝트에 기여해주셔서 다시 한 번 감사드립니다! 🙏** 