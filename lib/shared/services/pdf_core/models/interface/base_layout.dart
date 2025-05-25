// base_layout.dart

import 'package:flutter/services.dart';

enum LayoutType { formula, text, number, header, algorithm }

// PDF 레이아웃 데이터 모델 인터페이스
abstract class BaseLayout {
  // 레이아웃 타입
  LayoutType get type;

  // 레이아웃 내용
  String get content;

  // 텍스트 레이아웃일 경우 값을 가집니다.
  String? get text;

  // 수식 레이아웃일 경우 값을 가집니다. 라텍스 형식으로 저장합니다.
  String? get latex;

  // 레이아웃 위치
  Rect get rect;
}
