import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../shared/services/pdf_core/pdf_core.dart';
import '../models/pdf_viewer_view_model.dart';
import '../widgets/pdf_sidebar.dart';
import '../widgets/no_pdf_loaded_view.dart';
import '../widgets/pdf_bottom_bar.dart';

// 매직 넘버 상수 선언
const double kStatusBarHeight = 48;
const double kIconSize = 64;
const double kFontSize = 18;
const double kSpacingLarge = 16;
const double kSpacingSmall = 8;

class PDFViewer extends StatefulWidget {
  final String path;
  final bool isAsset;

  const PDFViewer({super.key, required this.path, this.isAsset = true});

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  PdfViewerViewModel? _viewModel;
  final PdfViewerController _pdfController = PdfViewerController();

  @override
  void initState() {
    super.initState();

    // Get PDFProvider from InheritedWidget after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pdfProvider = InheritedPDFProviderWidget.of(context).provider;
      setState(() {
        _viewModel = PdfViewerViewModel(pdfProvider: pdfProvider);
      });

      // Load initial PDF
      _viewModel!.loadPdf(path: widget.path, isAsset: widget.isAsset);
    });

    // Listen to PDF controller for page changes
    _pdfController.addListener(_onPdfControllerChanged);
  }

  void _onPdfControllerChanged() {
    if (_pdfController.isReady) {
      // Update current page in view model
      final pageNumber = _pdfController.pageNumber ?? 1;
      _viewModel?.updateCurrentPage(pageNumber);

      // Update zoom in view model
      final zoomRatio = _pdfController.currentZoom;
      _viewModel?.updateZoom(zoomRatio);
    }
  }

  void _onPageSelected(BasePage page) {
    // Jump to the selected page (page.pageIndex is 0-based, but controller expects 1-based)
    _pdfController.goToPage(pageNumber: page.pageIndex + 1);
  }

  void _onLayoutSelected(BaseLayout layout) {
    // For layouts, we need to find which page contains this layout
    // and jump to that page
    if (_viewModel != null) {
      for (final page in _viewModel!.pages) {
        page.getLayouts().then((layouts) {
          if (layouts.contains(layout)) {
            _pdfController.goToPage(pageNumber: page.pageIndex + 1);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _pdfController.removeListener(_onPdfControllerChanged);
    _viewModel?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel null 체크 분리
    if (_viewModel == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ListenableBuilder(
      listenable: _viewModel!,
      builder: (context, child) {
        // 1. 로딩 상태
        if (_viewModel!.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // 2. PDF 미로딩 상태
        if (_viewModel!.errorMessage != null) {
          return const Scaffold(body: NoPdfLoadedView());
        }
        // 3. 정상 상태
        return Scaffold(
          appBar: AppBar(title: Text(_viewModel!.pdfTitle), actions: []),
          body: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Main PDF Viewer Area
                    Expanded(
                      child: PdfViewer.file(
                        widget.path,
                        controller: _pdfController,
                        params: PdfViewerParams(
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceContainer,
                          pageOverlaysBuilder: (context, pageRect, page) {
                            return _buildPageOverlays(context, pageRect, page);
                          },
                        ),
                      ),
                    ),
                    // Bottom Status Bar
                    PDFBottomBar(
                      zoomPercent: _viewModel!.zoomPercent.toInt(),
                      currentPage: _viewModel!.currentPage,
                      totalPages: _viewModel!.pages.length,
                      sidebarVisible: _viewModel!.sidebarVisible,
                      onSidebarToggle: _viewModel!.toggleSidebar,
                    ),
                  ],
                ),
              ),
              // Sidebar
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  );
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                child:
                    _viewModel!.sidebarVisible
                        ? PdfSidebar(
                          key: const ValueKey('sidebar'),
                          viewModel: _viewModel!,
                          onPageSelected: _onPageSelected,
                          onLayoutSelected: _onLayoutSelected,
                        )
                        : const SizedBox.shrink(key: ValueKey('empty')),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildPageOverlays(
    BuildContext context,
    Rect pageRect,
    PdfPage page,
  ) {
    // Get the current page index (PdfPage.pageNumber is 1-based)
    final pageIndex = page.pageNumber - 1;

    // Check if we have view model
    if (_viewModel == null) {
      return [];
    }

    // Get the corresponding PageModel from our model
    if (pageIndex >= _viewModel!.pages.length) {
      return [];
    }
    final pageModel = _viewModel!.pages.firstWhere(
      (page) => page.pageIndex == pageIndex,
    );

    // Get figure references for this page
    final figureReferences = _viewModel!.getFigureReferencesForPage(pageIndex);

    if (figureReferences.isEmpty) {
      return [];
    }

    // scaleX, scaleY 각각 적용
    final scaleX = pageRect.width / pageModel.width.toDouble();
    final scaleY = pageRect.height / pageModel.height.toDouble();

    return figureReferences.map((reference) {
      final rect = reference.rect;

      // Direct coordinate transformation without Y-axis flip
      // The OCR coordinates appear to use top-left origin like Flutter
      final left = (rect.left * scaleX);
      final top = (rect.top * scaleY);
      final width = rect.width * scaleX;
      final height = rect.height * scaleY;

      return Positioned(
        left: left,
        top: top,
        width: width,
        height: height,
        child: GestureDetector(
          onTap: () {
            // TODO: Show figure popup when tapped
            print('Figure reference tapped: ${reference.referenceText}');
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ),
          ),
        ),
      );
    }).toList();
  }
}
