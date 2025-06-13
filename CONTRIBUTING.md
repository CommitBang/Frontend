# CONTRIBUTING.md

SnapFig 프로젝트에 기여해 주셔서 감사합니다! 🙏  
이 가이드는 이슈 등록, 기능 제안, 버그 수정, PR 제출 등 기여 과정을 안내합니다.

---

## 📋 목차

1. [기여 전 읽어주세요](#-기여-전-읽어주세요)
2. [이슈 등록하기](#-이슈-등록하기)
3. [새 기능 제안하기](#-새-기능-제안하기)
4. [개발 환경 설정](#-개발-환경-설정)
5. [브랜치 네이밍](#-브랜치-네이밍)
6. [커밋 메시지 형식](#-커밋-메시지-형식)
7. [Pull Request(PR) 절차](#-pull-requestpr-절차)
8. [코드 스타일 & 테스트](#-코드-스타일--테스트)
9. [리뷰 & 머지](#-리뷰--머지)
10. [문의 및 연락](#-문의-및-연락)

---

## 🤔 기여 전 읽어주세요

- 본 저장소의 **`main`** 브랜치는 프로덕션용으로, 직접 커밋 금지
- 모든 개발은 **`develop`** 브랜치에서 시작합니다
- 기능 개발, 버그 수정 등 기여 전 이 가이드를 반드시 숙지해 주세요

---

## 🐞 이슈 등록하기

1. 저장소 우측 상단의 **“Issues”** 탭 클릭
2. **Bug Report** 템플릿 선택
3. 문제 상황 재현 방법, 기대 동작, 실제 동작, 스크린샷(또는 로그) 포함

---

## 🎉 새 기능 제안하기

1. **Feature Request** 템플릿 선택
2. 제안하려는 기능 설명, 목적, 참고 자료(모바일 앱 흐름도, 목업 등) 포함
3. 가능하다면 구현 아이디어나 간단한 설계도 제안

---

## 🛠 개발 환경 설정

```bash
# 저장소 클론
git clone https://github.com/CommitBang/Frontend.git
cd Frontend

# Flutter 패키지 설치
flutter pub get
```

- Flutter SDK 및 Dart 최신 버전 권장
- IDE: Android Studio, VS Code 등 Flutter 지원 에디터

---

## 🌿 브랜치 네이밍

- feature/<설명>: 새로운 기능 개발
- bugfix/<설명>: 버그 수정
- hotfix/<설명>: 긴급 수정

```
예시
feature/ocr-text-highlighting
bugfix/pdf-render-error 
```

---

## 📝 커밋 메시지 형식

```text
<타입>: <설명>
[선택사항: 본문]
```

- type: feat, fix, docs, style, refactor, test, chore
- scope: 변경한 모듈 또는 기능 영역 (예: pdf_viewer, ocr_service)

```text
feat(pdf_viewer): 주석–Figure 팝업 UI 구현

- Figure tap 시 모달 팝업으로 상세 이미지 표시
- 관련 테스트 케이스 추가
```

---

## 🔀 Pull Request(PR) 절차

1. 이슈(버그/기능) 등록 또는 기존 이슈 선택
2. develop 브랜치에서 본인 작업 브랜치 생성
3. 작업 완료 후 커밋 & 푸시
4. GitHub에서 New Pull Request 클릭
5. PR 템플릿 작성
6. 리뷰어 지정 후 리뷰 요청

---

## 💅 코드 스타일 & 테스트

---

## ✅ 리뷰 & 머지

- PR은 최소 2명 이상의 리뷰어 승인 필요
- 리뷰 코멘트 반영 후 develop 브랜치에 머지
- main 브랜치로 머지는 릴리즈 담당자가 수행

---

## 📞 문의 및 연락