import 'package:flutter/foundation.dart';

import 'base_page.dart';

enum PDFStatus {
  // 대기 중
  pending,

  // 처리 중
  processing,

  // 완료
  completed,

  // 실패
  failed,
}

// PDF 데이터 모델 인터페이스
abstract class BasePdf {
  // 파일 이름
  String get name;

  // 파일 경로
  String get path;

  // 생성 시간
  DateTime get createdAt;

  // 수정 시간
  DateTime get updatedAt;

  // 총 페이지 수
  int get totalPages;

  // 현재 페이지 번호
  int get currentPage;

  // 파일 상태
  PDFStatus get status;

  // 썸네일 이미지
  Future<Uint8List?> getThumbnail();

  // 페이지 목록
  Future<List<BasePage>> getPages();
}
