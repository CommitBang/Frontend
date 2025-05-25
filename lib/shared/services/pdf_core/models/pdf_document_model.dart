// lib/shared/services/pdf_core/models/pdf_document_model.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';

import 'interface/base_pdf.dart';
import 'interface/base_page.dart';
import 'pdf_page_model.dart';
import 'pdf_layout_model.dart';

/// PDF 데이터 모델 구현체
class PdfDocumentModel implements BasePdf {
  final PdfDocument _doc;
  final String _name;
  final String _filePath;
  final List<PdfPageModel> _pages;

  PdfDocumentModel._(
      this._doc,
      this._name,
      this._filePath,
      this._pages,
      );

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

    final parsingBlocks = (ocr['parsing_res_list'] as List)
        .cast<Map<String, dynamic>>();
    final formulaBlocks = (ocr['formula_res_list'] as List)
        .cast<Map<String, dynamic>>();

    // 2) 페이지별 레이아웃 모으기
    final pages = <PdfPageModel>[];
    for (var i = 0; i < doc.pages.length; i++) {
      final layouts = <PdfLayoutModel>[];

      // parsing 블록
      for (final b in parsingBlocks) {
        final idx = b['page_index'] is int ? b['page_index'] as int : 0;
        if (idx == i) {
          layouts.add(PdfLayoutModel.fromParsingBlock(b, i));
        }
      }

      // formula 블록
      for (final b in formulaBlocks) {
        final idx = b['page_index'] is int ? b['page_index'] as int : 0;
        if (idx == i) {
          layouts.add(PdfLayoutModel.fromFormulaBlock(b, i));
        }
      }

      pages.add(PdfPageModel(
        document: doc,
        pageIndex: i,
        layouts: layouts,
      ));
    }

    return PdfDocumentModel._(doc, name, filePath, pages);
  }

  // --- BasePdf 구현 ---

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
  int get currentPage => 0; // UI에서 별도 관리

  @override
  PDFStatus get status => PDFStatus.completed;

  @override
  List<BasePage> getPages() => _pages;
}