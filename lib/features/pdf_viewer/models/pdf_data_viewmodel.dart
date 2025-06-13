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
  bool _isDataLoaded = false;
  bool _isLoading = true;
  bool _isError = false;
  String? _errorMessage;
  List<PdfOutlineNode> _outlines = [];

  bool get isDataLoaded => _isDataLoaded;
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
    super.dispose();
  }

  void loadPDFData(String path, PdfDocument pdfDocument) async {
    if (_isDataLoaded) return;
    _pdfDocument = pdfDocument;
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
      _outlines = await _pdfDocument!.loadOutline();
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
    _isDataLoaded = true;
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
    if (figure.type != LayoutType.figure || _pdfDocument == null) {
      print(
        '❌ Invalid input: figure type=${figure.type}, pdfDocument=${_pdfDocument != null}',
      );
      return null;
    }

    final pageIndex = getPageNumberForFigure(figure);
    if (pageIndex == null) {
      print('❌ Could not find page for figure: ${figure.figureId}');
      return null;
    }

    // Validate page index bounds
    if (pageIndex < 0 || pageIndex >= _pages.length) {
      print(
        '❌ Page index out of bounds: $pageIndex (total pages: ${_pages.length})',
      );
      return null;
    }

    // Convert 0-based index to 1-based page number for PDF document lookup
    final pageNumber = pageIndex + 1;
    final pageDoc = _pdfDocument!.pages.firstWhereOrNull(
      (p) => p.pageNumber == pageNumber,
    );
    if (pageDoc == null) {
      print('❌ Could not find PDF page: $pageNumber');
      return null;
    }

    print('✅ Processing figure on page $pageNumber (index: $pageIndex)');
    print('   PDF page size: ${pageDoc.width}x${pageDoc.height}');
    print(
      '   OCR page size: ${_pages[pageIndex].width}x${_pages[pageIndex].height}',
    );

    // Calculate scale factors
    final scaleX = pageDoc.width / _pages[pageIndex].width;
    final scaleY = pageDoc.height / _pages[pageIndex].height;

    print('   Scale factors: scaleX=$scaleX, scaleY=$scaleY');

    final figureRect = figure.rect;
    final left = figureRect.left * scaleX;
    final top = figureRect.top * scaleY;
    final width = figureRect.width * scaleX;
    final height = figureRect.height * scaleY;

    print('   Original rect: ${figureRect.toString()}');
    print('   Scaled rect: left=$left, top=$top, width=$width, height=$height');

    // Validate dimensions
    if (width <= 0 || height <= 0) {
      print('❌ Invalid dimensions after scaling');
      return null;
    }

    // Clamp coordinates to page bounds to prevent rendering errors
    final clampedLeft = left.clamp(0.0, pageDoc.width - 1);
    final clampedTop = top.clamp(0.0, pageDoc.height - 1);
    final clampedWidth = (width).clamp(1.0, pageDoc.width - clampedLeft);
    final clampedHeight = (height).clamp(1.0, pageDoc.height - clampedTop);

    if (clampedLeft != left ||
        clampedTop != top ||
        clampedWidth != width ||
        clampedHeight != height) {
      print(
        '⚠️  Clamped coordinates: left=$clampedLeft, top=$clampedTop, width=$clampedWidth, height=$clampedHeight',
      );
    }

    final image = await pageDoc.render(
      x: clampedLeft.toInt(),
      y: clampedTop.toInt(),
      width: clampedWidth.toInt(),
      height: clampedHeight.toInt(),
    );
    if (image == null) {
      print('❌ Failed to render image');
      return null;
    }
    final imageData = await image.createImage();
    print('✅ Successfully rendered figure image');
    return imageData;
  }
}
