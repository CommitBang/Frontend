// lib/shared/services/pdf_core/models/pdf_document_model.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:isar/isar.dart';

import '../../../shared/services/pdf_core/models/interface/base_pdf.dart';
import '../../../shared/services/pdf_core/models/interface/base_page.dart';
import 'pdf_page_model.dart';
import 'pdf_layout_model.dart';

/// PDF 데이터 모델 구현체
class PdfDocumentModel implements BasePdf {
  final String _name;
  final String _filePath;
  final List<PdfPageModel> _pages;

  PdfDocumentModel._(this._name, this._filePath, this._pages);

  /// PdfDocument → PdfDocumentModel
  /// - name: 파일명
  /// - filePath: 경로 또는 asset 식별자
  static Future<PdfDocumentModel> fromDocument(
    PdfDocument doc, {
    required String name,
    required String filePath,
  }) async {
    // 1) OCR/파싱 JSON 불러오기
    final raw = await rootBundle.loadString('assets/ocr_result.json');
    final ocr = json.decode(raw) as Map<String, dynamic>;

    final parsingBlocks =
        (ocr['parsing_res_list'] as List).cast<Map<String, dynamic>>();
    final formulaBlocks =
        (ocr['formula_res_list'] as List).cast<Map<String, dynamic>>();

    // 2) 페이지별 레이아웃 모으기
    final pages = <PdfPageModel>[];
    for (var i = 0; i < doc.pages.length; i++) {
      final layouts = <PdfLayoutModel>[];

      for (final b in parsingBlocks) {
        final idx = b['page_index'] is int ? b['page_index'] as int : 0;
        if (idx == i) {
          layouts.add(PdfLayoutModel.fromParsingBlock(b, i));
        }
      }

      for (final b in formulaBlocks) {
        final idx = b['page_index'] is int ? b['page_index'] as int : 0;
        if (idx == i) {
          layouts.add(PdfLayoutModel.fromFormulaBlock(b, i));
        }
      }

      pages.add(PdfPageModel(document: doc, pageIndex: i, layouts: layouts));
    }

    return PdfDocumentModel._(name, filePath, pages);
  }

  // --- BasePdf 구현 ---

  /// 고유 식별자: 여기서는 파일 경로 해시코드를 사용
  @override
  Id get id => _filePath.hashCode;

  @override
  String get name => _name;

  @override
  String get path => _filePath;

  @override
  DateTime get createdAt => DateTime.now();

  @override
  DateTime get updatedAt => DateTime.now();

  @override
  int get totalPages => _pages.length;

  @override
  int get currentPage => 0; // UI에서 별도 관리하도록 대체 가능

  @override
  PDFStatus get status => PDFStatus.completed;

  /// 썸네일 바이트 (null로 두거나, 미리 렌더링한 바이트를 리턴할 수 있습니다)
  @override
  List<int>? get thumbnail => null;

  /// 페이지 목록을 Future로 반환하도록 시그니처 변경
  @override
  Future<List<BasePage>> getPages() async {
    // 이미 PdfPageModel 타입의 리스트이므로 그대로 반환
    return _pages;
  }
}
