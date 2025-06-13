# 개발 프로세스

## 개발 방법론

- **Agile (XP)**: 2주 스프린트, 데일리 스탠드업, 페어 프로그래밍
- **공동 소유권**: 모든 코드에 팀원 모두가 기여 가능

## 브랜치 전략

- `main`: 프로덕션 코드
- `develop`: 통합 개발 브랜치
- `feature/*`: 기능 개발
- `bugfix/*`: 버그 수정
- `hotfix/*`: 긴급 수정

## CI/CD 파이프라인

1. **GitHub Actions**
    - Push 시 `develop` 브랜치 빌드 & 테스트 자동 실행
    - PR 생성 시 lint, format, unit/widget 테스트 수행
2. **Docker**: 백엔드 컨테이너 이미지 자동 빌드
3. **배포**: `main` 브랜치 merge 시 도커 허브 및 서버 배포 트리거

## 코드 리뷰 & 품질 관리

- **PR 리뷰**: 최소 2명 승인 후 merge
- **Lint**: `flutter analyze`, `flake8`
- **Format**: `flutter format`, `black`
- **테스트 커버리지**: 최소 80%