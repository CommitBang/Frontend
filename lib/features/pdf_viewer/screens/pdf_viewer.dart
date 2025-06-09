import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:snapfig/features/pdf_viewer/models/pdf_viewer_viewmodel.dart';
import 'package:snapfig/features/pdf_viewer/widgets/sidebar/pdf_sidebar.dart';

import '../../../shared/services/pdf_core/pdf_core.dart';
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

  const PDFViewer({super.key, required this.path});

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  PDFDataViewModel? _viewModel;
  final PdfViewerController _pdfController = PdfViewerController();
  bool _sidebarVisible = true;

  @override
  void initState() {
    super.initState();

    // Get PDFProvider from InheritedWidget after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pdfProvider = InheritedPDFProviderWidget.of(context).provider;
      setState(() {
        _viewModel = PDFDataViewModel(pdfProvider: pdfProvider);
      });

      // Load initial PDF
      _viewModel!.loadPDF(widget.path);
    });
  }

  void _onOutlineSelected(PdfOutlineNode outline) {
    if (outline.dest == null) return;
    _pdfController.goToPage(pageNumber: outline.dest!.pageNumber);
  }

  void _onFigureSelected(BaseLayout layout) {
    // Navigate to the page containing this figure
    if (_viewModel != null && layout.type == LayoutType.figure) {
      final pageNumber = _viewModel!.getPageNumberForFigure(layout);
      if (pageNumber != null) {
        _pdfController.goToPage(pageNumber: pageNumber);
      } else {
        // Show error message if figure page not found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to navigate to figure'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _onSidebarToggle() {
    setState(() {
      _sidebarVisible = !_sidebarVisible;
    });
  }

  @override
  void dispose() {
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
        if (_viewModel!.isFailed) {
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
                            return _buildReferenceHighlights(
                              context,
                              pageRect,
                              page.pageNumber,
                            );
                          },
                        ),
                      ),
                    ),
                    // Bottom Status Bar
                    PDFBottomBar(
                      zoomPercent: (_pdfController.currentZoom * 100).toInt(),
                      currentPage: _pdfController.pageNumber ?? 1,
                      totalPages: _viewModel!.pages.length,
                      sidebarVisible: _sidebarVisible,
                      onSidebarToggle: _onSidebarToggle,
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
                    _sidebarVisible
                        ? PDFSideBar(
                          viewModel: _viewModel!,
                          onPageSelected: _onOutlineSelected,
                          onFigureSelected: _onFigureSelected,
                        )
                        : const SizedBox.shrink(key: ValueKey('empty')),
              ),
            ],
          ),
        );
      },
    );
  }

  // Reference highlight
  List<Widget> _buildReferenceHighlights(
    BuildContext context,
    Rect pageRect,
    int pageNumber,
  ) {
    final layouts = _viewModel!.layoutsByPage[pageNumber];
    final page = _viewModel!.pages[pageNumber];
    if (layouts == null) return [];
    final references = layouts.where(
      (layout) => layout.type == LayoutType.figureReference,
    );
    final scaleX = pageRect.width / page.width.toDouble();
    final scaleY = pageRect.height / page.height.toDouble();
    return references.map((reference) {
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
        child: Builder(
          builder: (innerContext) {
            final theme = Theme.of(innerContext);
            return GestureDetector(
              onTap: () {
                _onFigureSelected(reference);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer.withValues(
                    alpha: 0.2,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }).toList();
  }
}
