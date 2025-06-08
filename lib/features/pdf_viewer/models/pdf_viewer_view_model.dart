import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';

import '../../../shared/services/pdf_core/pdf_core.dart';

class PdfViewerViewModel extends ChangeNotifier {
  // Private state
  BasePdf? _pdfModel;
  List<BasePage> _pages = [];
  List<BaseLayout> _layouts = [];
  Map<int, List<BaseLayout>> _layoutsByPage = {};

  // UI state
  double _zoomPercent = 100.0;
  int _currentPage = 1;
  String _pdfTitle = 'PDF Viewer';
  String _searchQuery = '';
  bool _sidebarVisible = true;
  int _selectedTabIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // Dependencies
  final PDFProvider _pdfProvider;

  PdfViewerViewModel({required PDFProvider pdfProvider})
    : _pdfProvider = pdfProvider;

  BasePdf? get pdfModel => _pdfModel;
  List<BasePage> get pages => _pages;
  List<BaseLayout> get layouts => _layouts;

  double get zoomPercent => _zoomPercent;
  int get currentPage => _currentPage;
  String get pdfTitle => _pdfTitle;
  String get searchQuery => _searchQuery;
  bool get sidebarVisible => _sidebarVisible;
  int get selectedTabIndex => _selectedTabIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Filtered data
  List<BasePage> get filteredPages =>
      _pages
          .where((p) => p.pageIndex.toString().contains(_searchQuery))
          .toList();

  List<BaseLayout> get filteredLayouts =>
      _layouts
          .where((l) => l.type == LayoutType.figure)
          .where(
            (l) =>
                l.figureId?.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ??
                false,
          )
          .toList();

  // Get layouts for a specific page
  List<BaseLayout> getLayoutsForPage(int pageIndex) {
    return _layoutsByPage[pageIndex] ?? [];
  }

  // Get figure references for a specific page
  List<BaseLayout> getFigureReferencesForPage(int pageIndex) {
    return getLayoutsForPage(
      pageIndex,
    ).where((layout) => layout.type == LayoutType.figureReference).toList();
  }

  // Get all figure references
  List<BaseLayout> get figureReferences =>
      _layouts
          .where((layout) => layout.type == LayoutType.figureReference)
          .toList();

  // Get all figures
  List<BaseLayout> get figures =>
      _layouts.where((layout) => layout.type == LayoutType.figure).toList();

  // Find figure by ID
  BaseLayout? findFigureById(String figureId) {
    try {
      return figures.firstWhere((figure) => figure.figureId == figureId);
    } catch (e) {
      return null;
    }
  }

  // Find figure by referenced figure ID
  BaseLayout? findFigureByReference(BaseLayout reference) {
    if (reference.type != LayoutType.figureReference) return null;
    final referencedId = reference.referencedFigureId;
    if (referencedId == null) return null;
    return findFigureById(referencedId);
  }

  // Get page containing a specific layout
  BasePage? getPageForLayout(BaseLayout layout) {
    for (final entry in _layoutsByPage.entries) {
      if (entry.value.contains(layout)) {
        return _pages.firstWhere((page) => page.pageIndex == entry.key);
      }
    }
    return null;
  }

  // Navigate to a specific figure by finding its page
  int? getPageNumberForFigure(BaseLayout figure) {
    if (figure.type != LayoutType.figure) return null;

    final page = getPageForLayout(figure);
    if (page != null) {
      return page.pageIndex +
          1; // Convert to 1-based page number for PDF controller
    }
    return null;
  }

  // Methods
  Future<void> loadPdf({required String path, required bool isAsset}) async {
    try {
      _setLoading(true);
      _clearError();

      // 2. Get PDF from provider by path
      final model = await _pdfProvider.getPDF(path);

      if (model == null) {
        throw StateError('PDF not found in provider: $path');
      }

      // 3. Load pages and layouts
      final pages = await model.getPages();
      final allLayouts = <BaseLayout>[];
      final layoutsByPage = <int, List<BaseLayout>>{};

      for (final page in pages) {
        final layouts = await page.getLayouts();
        allLayouts.addAll(layouts);
        layoutsByPage[page.pageIndex] = layouts;
      }

      // 4. Update state
      _pdfModel = model;
      _pages = pages;
      _layouts = allLayouts;
      _layoutsByPage = layoutsByPage;
      _currentPage = 1;
      _zoomPercent = 100.0;
      _pdfTitle = model.name;

      notifyListeners();
    } catch (e) {
      _setError('Failed to load PDF: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> pickPdfFromDevice() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        await loadPdf(path: result.files.single.path!, isAsset: false);
      }
    } catch (e) {
      _setError('Failed to pick PDF: $e');
    }
  }

  void updateZoom(double scale) {
    _zoomPercent = (scale * 100).roundToDouble();
    notifyListeners();
  }

  void updateCurrentPage(int pageIndex) {
    _currentPage = pageIndex;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleSidebar() {
    _sidebarVisible = !_sidebarVisible;
    notifyListeners();
  }

  void selectTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }

  // Private helpers
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
