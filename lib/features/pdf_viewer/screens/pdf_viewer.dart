import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:snapfig/features/pdf_viewer/models/pdf_data_viewmodel.dart';
import 'package:snapfig/features/pdf_viewer/widgets/sidebar/pdf_sidebar.dart';
import 'package:snapfig/features/pdf_viewer/widgets/figure_overlay_widget.dart';
import 'package:snapfig/features/pdf_viewer/widgets/popover_wrapper.dart';

import '../../../shared/services/pdf_core/pdf_core.dart';
import '../widgets/pdf_bottom_bar.dart';

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
      _pdfController.addListener(() {
        if (_pdfController.isReady) {
          _pdfController.useDocument((doc) {
            _viewModel?.loadPDFData(widget.path, doc);
          });
        }
      });
    });
  }

  void _onOutlineSelected(PdfOutlineNode outline) {
    if (outline.dest == null) return;
    _pdfController.goToPage(pageNumber: outline.dest!.pageNumber);
  }

  void _onFigureSelected(BaseLayout layout) {
    // Show figure overlay popup when reference is tapped
    if (layout.type != LayoutType.figure) return;
    final pageNumber = _viewModel!.getPageNumberForFigure(layout);
    if (pageNumber == null) return;
    _pdfController.goToPage(pageNumber: pageNumber);
  }

  void _showFigurePopover(BaseLayout reference) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    // Get the position where the tap occurred
    final overlay = Overlay.of(context);
    final pageNumber = _viewModel!.getPageNumberForReference(reference);
    if (pageNumber == null) return;

    // Calculate position based on the reference location
    final page = _viewModel!.pages[pageNumber];
    final pageRect = Rect.fromLTWH(
      0,
      0,
      page.width.toDouble(),
      page.height.toDouble(),
    ); // TODO: FIXXXX
    if (pageRect == null) return;

    final scaleX = pageRect.width / page.width.toDouble();
    final scaleY = pageRect.height / page.height.toDouble();

    final referenceCenter = Offset(
      pageRect.left + (reference.rect.center.dx * scaleX),
      pageRect.top + (reference.rect.center.dy * scaleY),
    );

    final overlayEntry = OverlayEntry(
      builder:
          (context) => PopoverWrapper(
            targetPosition: referenceCenter,
            onDismiss: () {},
            child: FigureOverlayWidget(
              reference: reference,
              viewModel: _viewModel!,
              onClose: () {},
              navigateToFigure: (figure) {
                _navigateToFigure(figure);
              },
            ),
          ),
    );

    overlay.insert(overlayEntry);
  }

  void _navigateToFigure(BaseLayout figure) {
    final pageNumber = _viewModel!.getPageNumberForFigure(figure);
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
                            print('pageOverlaysBuilder: ${page.pageNumber}');
                            return _buildReferenceHighlights(
                              context,
                              pageRect,
                              page.pageNumber,
                            );
                          },
                        ),
                      ),
                    ),
                    if (_pdfController.isReady)
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
                        ? _buildSideBar(context)
                        : const SizedBox.shrink(key: ValueKey('empty')),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSideBar(BuildContext context) {
    final theme = Theme.of(context);
    if (_viewModel?.isDataLoaded ?? false) {
      return PDFSideBar(
        viewModel: _viewModel!,
        onPageSelected: _onOutlineSelected,
        onFigureSelected: _onFigureSelected,
      );
    } else if (_viewModel?.isLoading ?? false) {
      return Container(
        width: 300,
        color: theme.colorScheme.surfaceContainer,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Loading PDF...', style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      );
    } else {
      return Container(
        color: theme.colorScheme.surfaceContainer,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'PDF data not loaded',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  // Reference highlight
  List<Widget> _buildReferenceHighlights(
    BuildContext context,
    Rect pageRect,
    int pageNumber,
  ) {
    if (_viewModel == null || _viewModel!.isLoading) return [];
    final pageIndex = pageNumber - 1;
    final layouts = _viewModel!.layoutsByPage[pageIndex];
    final page = _viewModel!.pages[pageIndex];
    if (layouts == null) return [];
    final references = layouts.where(
      (layout) => layout.type == LayoutType.figureReference,
    );

    // 페이지 크기 비율 계산 - OCR 좌표를 뷰어 좌표로 변환
    final scaleX = pageRect.width / page.width.toDouble();
    final scaleY = pageRect.height / page.height.toDouble();

    print('=== Page $pageNumber Highlights Debug ===');
    print('References found: ${references.length}');
    print('OCR page size: ${page.width}x${page.height}');
    print('PageRect: ${pageRect.toString()}');
    print('PageRect size: ${pageRect.width}x${pageRect.height}');
    print('PageRect offset: ${pageRect.left}, ${pageRect.top}');
    print('Scale factors: scaleX=$scaleX, scaleY=$scaleY');

    return references.map((reference) {
      final rect = reference.rect;

      // Transform OCR coordinates to page coordinates
      final left = rect.left * scaleX;
      final top = rect.top * scaleY;
      final width = rect.width * scaleX;
      final height = rect.height * scaleY;

      // Debug output
      print('  Figure: ${reference.content}');
      print('  OCR rect: ${rect.toString()}');
      print('  Scaled: left=$left, top=$top, width=$width, height=$height');
      print('  PageRect: ${pageRect.toString()}');

      // Basic validation
      if (width <= 0 || height <= 0) {
        print('  ❌ Invalid dimensions, skipping');
        return const SizedBox.shrink();
      }

      // Skip if completely outside page bounds
      if (left + width < 0 ||
          left > pageRect.width ||
          top + height < 0 ||
          top > pageRect.height) {
        print('  ❌ Completely outside page bounds, skipping');
        return const SizedBox.shrink();
      }

      return Positioned(
        left: left,
        top: top,
        width: width,
        height: height,
        child: _buildHighlightWidget(context, reference),
      );
    }).toList();
  }

  // 하이라이트 위젯을 별도 메서드로 분리
  Widget _buildHighlightWidget(BuildContext context, BaseLayout reference) {
    return Builder(
      builder: (innerContext) {
        final theme = Theme.of(innerContext);
        return GestureDetector(
          onTap: () {
            print('Tapped reference: ${reference.content}');
            _onFigureSelected(reference);
          },
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        );
      },
    );
  }
}
