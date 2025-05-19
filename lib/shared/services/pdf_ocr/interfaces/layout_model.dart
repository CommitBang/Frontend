import 'package:flutter/services.dart';

/// Text Detection시 지원하는 레이아웃 유형
enum LayoutType {
  text,
  picture,
  caption,
  sectionHeader,
  footnote,
  formula,
  table,
  listItem,
  pageHeader,
  pageFooter,
  title,
  unknown,
}

/// 문서에서 인식된 레이아웃 정보
class LayoutData {
  final int id;

  /// 레이아웃 유형
  final LayoutType type;

  /// 레이아웃 좌표
  final Rect coordinate;

  /// 레이아웃 인식 신뢰도
  final double confidence;

  LayoutData({
    required this.id,
    required this.type,
    required this.confidence,
    required this.coordinate,
  });
}
