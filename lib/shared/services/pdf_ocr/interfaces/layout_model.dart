import 'package:flutter/services.dart';

/// Text Detection시 지원하는 레이아웃 유형
enum LayoutType {
  documentTitle,
  paragraphTitle,
  text,
  pageNumber,
  abstractContent,
  tableOfContents,
  references,
  footnotes,
  header,
  footer,
  algorithm,
  formula,
  formulaNumber,
  image,
  figureCaption,
  figureTitle,
  figure,
  table,
  tableCaption,
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

  /// 레이아웃에 해당하는 이미지
  final Uint8List? imgBitmap;

  /// 레이아웃 이미지 크기
  final Size? imgSize;

  LayoutData({
    required this.id,
    required this.type,
    required this.confidence,
    required this.coordinate,
    this.imgBitmap,
    this.imgSize,
  });
}
