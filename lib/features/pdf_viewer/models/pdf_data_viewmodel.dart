import 'package:flutter/material.dart';
import 'package:snapfig/shared/services/pdf_core/pdf_core.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:collection/collection.dart';
import 'dart:ui' as ui;

class PDFDataViewModel extends ChangeNotifier {
  final PDFProvider _pdfProvider;
  // Pdf Ocr result
  BasePdf? _pdfModel;
  List<BasePage> _pages = [];
  Map<int, List<BaseLayout>> _layoutsByPage = {};
  // Pdf data
  PdfDocument? _pdfDocument;
  bool _isLoading = true;
  bool _isError = false;
  String? _errorMessage;
  List<PdfOutlineNode> _outlines = [];

  bool get isLoading => _isLoading;
  bool get isFailed => _isError;
  String? get errorMessage => _errorMessage;
  List<PdfOutlineNode> get outlines => _outlines;
  Map<int, List<BaseLayout>> get layoutsByPage => _layoutsByPage;
  List<BasePage> get pages => _pages;
  List<BaseLayout> get figures =>
      _layoutsByPage.values
          .expand((e) => e)
          .where((e) => e.type == LayoutType.figure)
          .toList();
  String get pdfTitle => _pdfModel?.name ?? '';

  PDFDataViewModel({required PDFProvider pdfProvider})
    : _pdfProvider = pdfProvider;

  @override
  void dispose() {
    _pdfDocument?.dispose();
    super.dispose();
  }

  void loadPDF(String path) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load pdf model from database
      final pdfModel = await _pdfProvider.getPDF(path);
      if (pdfModel == null) {
        _isError = true;
        _errorMessage = 'OCR처리가 완료되지 않은 파일입니다.';
        notifyListeners();
        return;
      }
      _pages = await pdfModel.getPages();
      _pdfModel = pdfModel;
      _pdfDocument = await PdfDocument.openFile(path);
      _outlines = await _pdfDocument?.loadOutline() ?? [];
      _layoutsByPage = await Future.wait(
        _pages.map((page) async {
          final layouts = await page.getLayouts();
          return {page.pageIndex: layouts.toList()};
        }),
      ).then((value) => Map.fromEntries(value.expand((e) => e.entries)));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isError = true;
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  int? getPageNumberForFigure(BaseLayout figure) {
    if (figure.type != LayoutType.figure) return null;
    return _layoutsByPage.entries
        .firstWhereOrNull((entry) => entry.value.contains(figure))
        ?.key;
  }

  int? getPageNumberForReference(BaseLayout reference) {
    if (reference.type != LayoutType.figureReference) return null;
    return _layoutsByPage.entries
        .firstWhereOrNull((entry) => entry.value.contains(reference))
        ?.key;
  }

  BaseLayout? findFigureByReference(BaseLayout reference) {
    if (reference.type != LayoutType.figureReference) return null;
    final referencedId = reference.referencedFigureId;
    if (referencedId == null) return null;
    return _layoutsByPage.entries
        .expand((entry) => entry.value)
        .firstWhereOrNull((layout) => layout.figureId == referencedId);
  }

  Future<ui.Image?> getFigureImage(BaseLayout figure) async {
    if (figure.type != LayoutType.figure) return null;
    final pageIndex = getPageNumberForFigure(figure);
    if (pageIndex == null) return null;
    final pageDoc = _pdfDocument!.pages.firstWhereOrNull(
      (p) => p.pageNumber == pageIndex,
    );
    if (pageDoc == null) return null;

    final scaleX = pageDoc.width / _pages[pageIndex].width;
    final scaleY = pageDoc.height / _pages[pageIndex].height;
    final figureRect = figure.rect;
    final left = figureRect.left * scaleX;
    final top = figureRect.top * scaleY;
    final width = figureRect.width * scaleX;
    final height = figureRect.height * scaleY;

    final image = await pageDoc.render(
      x: left.toInt(),
      y: top.toInt(),
      width: width.toInt(),
      height: height.toInt(),
    );
    if (image == null) return null;
    final imageData = await image.createImage();
    return imageData;
  }
}
