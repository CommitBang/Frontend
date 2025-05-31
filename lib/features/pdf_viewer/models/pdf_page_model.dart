// lib/shared/services/pdf_core/models/pdf_page_model.dart

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:isar/isar.dart';

import '../../../shared/services/pdf_core/models/interface/base_page.dart';
import '../../../shared/services/pdf_core/models/interface/base_layout.dart';
import 'package:snapfig/shared/services/pdf_service.dart';

/// BasePage 인터페이스 구현체
class PdfPageModel implements BasePage {
  /// 0-based 페이지 인덱스
  @override
  final int pageIndex;

  final PdfDocument _document;
  final List<BaseLayout> _layouts;

  PdfPageModel({
    required PdfDocument document,
    required this.pageIndex,
    required List<BaseLayout> layouts,
  }) : _document = document,
       _layouts = layouts;

  /// --- BasePage 구현 ---

  /// 고유 식별자: 페이지 인덱스를 그대로 사용하거나,
  /// 필요시 hash 조합 등으로 바꿀 수 있습니다.
  @override
  Id get id => pageIndex;

  /// 페이지 크기
  @override
  Size get size =>
      Size(_document.pages[pageIndex].width, _document.pages[pageIndex].height);

  /// 페이지 전체 텍스트 (예: OCR 연동 필요 시 교체)
  @override
  String get fullText => '';

  /// 레이아웃 목록을 Future 형태로 반환
  @override
  Future<List<BaseLayout>> getLayouts() async => _layouts;

  /// --- 썸네일 기능 ---

  /// 화면에 보여줄 페이지 축소판 위젯
  Widget thumbnailWidget({double width = 80, double height = 120}) {
    return FutureBuilder<Uint8List>(
      future: getThumbnailBytes(pageIndex, width.toInt(), height.toInt()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.memory(
              snapshot.data!,
              width: width,
              height: height,
              fit: BoxFit.contain, // 전체가 보이도록
              alignment: Alignment.topCenter,
            ),
          );
        }
        return SizedBox(
          width: width,
          height: height,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
    );
  }

  /// 전역 PdfService.instance.currentDocument 에서
  /// [pageIndex] 페이지를 [w]×[h] 크기로 렌더링하고
  /// PNG 바이트로 반환하는 정적 헬퍼
  static Future<Uint8List> getThumbnailBytes(
    int pageIndex,
    int w,
    int h,
  ) async {
    final doc = PdfService.instance.currentDocument;
    if (doc == null) {
      throw StateError('PDF 문서가 아직 로드되지 않았습니다.');
    }

    final PdfImage? pdfImage = await doc.pages[pageIndex].render(
      width: w,
      height: h,
    );
    if (pdfImage == null) {
      throw StateError('페이지 렌더링 실패 index=$pageIndex');
    }

    final ui.Image img = await pdfImage.createImage();
    pdfImage.dispose();

    final ByteData? bd = await img.toByteData(format: ui.ImageByteFormat.png);
    if (bd == null) {
      throw StateError('PNG 바이트 변환 실패 index=$pageIndex');
    }
    return bd.buffer.asUint8List();
  }
}
