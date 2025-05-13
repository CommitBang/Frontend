import 'package:flutter/services.dart';

import './layout_model.dart';

/// 레이아웃에 해당하는 부분의 데이터
class SectionData {
  /// 레이아웃 정보
  final LayoutData layout;

  /// 텍스트 정보
  final String text;

  /// 레이텍스 수식 정보, 레이아웃 유형이 [LayoutType.formula]인 경우에만 존재
  final String? latexFormula;

  /// 이미지 비트맵, 레이아웃 유형이 [LayoutType.image]인 경우에만 존재
  final Uint8List? imgBitmap;

  /// 이미지 크기, 레이아웃 유형이 [LayoutType.image]인 경우에만 존재
  final Size? imgSize;

  /// 레이아웃 인식 신뢰도
  final double confidence;

  SectionData({
    required this.layout,
    required this.confidence,
    required this.text,
    this.latexFormula,
    this.imgBitmap,
    this.imgSize,
  });
}

/// 문서 인식 결과
class DocumentData {
  /// 레이아웃에 해당하는 부분의 데이터
  final List<SectionData> sections;

  DocumentData({required this.sections});
}
