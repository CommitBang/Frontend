// lib/shared/services/pdf_core/models/pdf_layout_model.dart

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'interface/base_layout.dart';
import 'pdf_page_model.dart';

/// PDF 문서 내 레이아웃(텍스트, 수식, 헤더, 알고리즘 등)을 나타내는 모델
class PdfLayoutModel implements BaseLayout {
  /// 이 레이아웃이 속한 페이지 인덱스 (0-based)
  final int pageIndex;

  @override
  final LayoutType type;

  @override
  final String content;

  @override
  final String? text;

  @override
  final String? latex;

  @override
  final Rect rect;

  PdfLayoutModel({
    required this.pageIndex,
    required this.type,
    required this.content,
    this.text,
    this.latex,
    required this.rect,
  });

  /// OCR 파싱 결과 블록에서 모델 생성
  ///
  /// JSON 필드:
  /// - block_label: "text"|"formula"|"header"|"number"|"algorithm"
  /// - block_content: 블록 내 원본 텍스트
  /// - block_bbox: [x0, y0, x1, y1]
  factory PdfLayoutModel.fromParsingBlock(
      Map<String, dynamic> block,
      int pageIndex,
      ) {
    final label = block['block_label'] as String;
    final type = LayoutType.values.firstWhere(
          (e) => e.toString().endsWith(label),
      orElse: () => LayoutType.text,
    );
    final bbox = (block['block_bbox'] as List).cast<num>();
    return PdfLayoutModel(
      pageIndex: pageIndex,
      type: type,
      content: block['block_content'] as String,
      text: type == LayoutType.text ? block['block_content'] as String : null,
      latex: type == LayoutType.formula ? block['block_content'] as String : null,
      rect: Rect.fromLTWH(
        bbox[0].toDouble(),
        bbox[1].toDouble(),
        (bbox[2] - bbox[0]).toDouble(),
        (bbox[3] - bbox[1]).toDouble(),
      ),
    );
  }

  /// 수식 인식 결과 블록에서 모델 생성
  ///
  /// JSON 필드:
  /// - rec_formula: 인식된 LaTeX 수식 문자열
  /// - dt_polys: [x0, y0, x1, y1]
  factory PdfLayoutModel.fromFormulaBlock(
      Map<String, dynamic> block,
      int pageIndex,
      ) {
    final polys = (block['dt_polys'] as List).cast<num>();
    return PdfLayoutModel(
      pageIndex: pageIndex,
      type: LayoutType.formula,
      content: block['rec_formula'] as String,
      text: null,
      latex: block['rec_formula'] as String,
      rect: Rect.fromLTWH(
        polys[0].toDouble(),
        polys[1].toDouble(),
        (polys[2] - polys[0]).toDouble(),
        (polys[3] - polys[1]).toDouble(),
      ),
    );
  }

  /// 이 레이아웃 블록 영역만 잘라낸 썸네일 위젯을 반환합니다.
  /// 내부적으로 PdfPageModel.getThumbnailBytes를 호출하여
  /// 지정된 크기로 렌더링된 페이지 이미지 바이트를 비동기로 가져옵니다.
  Widget thumbnailWidget({
    double width = 60,
    double height = 80,
  }) {
    return FutureBuilder<Uint8List>(
      future: PdfPageModel.getThumbnailBytes(pageIndex, width.toInt(), height.toInt()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return Image.memory(
            snapshot.data!,
            width: width,
            height: height,
            fit: BoxFit.cover,
          );
        } else {
          return SizedBox(
            width: width,
            height: height,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
      },
    );
  }
}