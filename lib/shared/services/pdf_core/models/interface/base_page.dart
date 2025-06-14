// base_page.dart

import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'base_layout.dart';

// PDF 페이지 데이터 모델 인터페이스
abstract class BasePage {
  // 고유 식별자
  Id get id;

  // 페이지 번호
  int get pageIndex;

  // 페이지 크기
  @ignore
  Size get size;

  // 페이지 전체 텍스트
  String get fullText;

  int get width;
  int get height;

  // 레이아웃 목록
  Future<List<BaseLayout>> getLayouts();
}
