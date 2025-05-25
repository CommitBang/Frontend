// lib/shared/services/pdf_core/models/pdf_page_model.dart

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

import 'interface/base_page.dart';
import 'interface/base_layout.dart';
import 'package:pdf_viewer/shared/services/pdf_service.dart';

/// BasePage 인터페이스 구현체
class PdfPageModel implements BasePage {
  @override
  final int pageIndex;
  final PdfDocument _document;
  final List<BaseLayout> _layouts;

  PdfPageModel({
    required PdfDocument document,
    required this.pageIndex,
    required List<BaseLayout> layouts,
  })  : _document = document,
        _layouts = layouts;

  @override
  Size get size => Size(
    _document.pages[pageIndex].width,
    _document.pages[pageIndex].height,
  );

  @override
  String get fullText => '';

  @override
  List<BaseLayout> getLayouts() => _layouts;

  /// 이 페이지 전체를 [width]×[height] 크기로 렌더링한 축소판을 반환합니다.
  /// BoxFit.contain 으로 설정해 이미지가 잘리지 않고 전체가 보이도록 합니다.
  Widget thumbnailWidget({
    double width = 80,
    double height = 120,
  }) {
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
              fit: BoxFit.contain,          // ← 변경: contain 으로 전체 보이게
              alignment: Alignment.topCenter,
            ),
          );
        }
        return SizedBox(
          width: width,
          height: height,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }

  /// 전역 PdfService.instance.currentDocument 에서
  /// [pageIndex] 페이지를 [w]×[h] 크기로 렌더링하고
  /// PNG 바이트로 반환하는 정적 헬퍼
  static Future<Uint8List> getThumbnailBytes(
      int pageIndex, int w, int h) async {
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

    final ByteData? bd = await img.toByteData(
      format: ui.ImageByteFormat.png,
    );
    if (bd == null) {
      throw StateError('PNG 바이트 변환 실패 index=$pageIndex');
    }
    return bd.buffer.asUint8List();
  }
}