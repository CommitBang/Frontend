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
        child: Builder(
          builder: (innerContext) {
            return GestureDetector(
              onTap: () {
                // Get the render box of this specific widget
                final RenderBox renderBox = innerContext.findRenderObject() as RenderBox;
                // Calculate center position in local coordinates
                final localCenter = Offset(width / 2, height / 2);
                // Convert to global coordinates
                final globalPosition = renderBox.localToGlobal(localCenter);
                _showFigurePopup(context, reference, globalPosition);
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
            );
          },
        ),
      );
    }).toList();
  }

  Future<void> _showFigurePopup(
    BuildContext context,
    BaseLayout reference,
    Offset globalPosition,
  ) async {
    // Find the corresponding figure
    final figure = _viewModel?.findFigureByReference(reference);
    if (figure == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Figure not found: ${reference.referenceText}'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Find which page contains the figure
    final figurePage = _viewModel?.getPageForLayout(figure);
    if (figurePage == null) return;

    // Show the figure in a custom overlay
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _FigurePopupOverlay(
        figure: figure,
        figurePage: figurePage,
        targetPosition: globalPosition,
        onClose: () => overlayEntry.remove(),
        renderFigure: _renderFigure,
      ),
    );

    overlay.insert(overlayEntry);
  }

  Future<Widget> _renderFigure(int pageIndex, BaseLayout figure) async {
    try {
      // Load the PDF document
      final document = await PdfDocument.openFile(widget.path);

      // Get the specific page (pageIndex is 0-based)
      final page = document.pages[pageIndex];

      // Get page dimensions from the PageModel (OCR coordinates)
      final pageModel = _viewModel!.pages.firstWhere(
        (p) => p.pageIndex == pageIndex,
      );
      final ocrPageWidth = pageModel.width.toDouble();
      final ocrPageHeight = pageModel.height.toDouble();

      // Get the figure's bounding box (in OCR coordinates)
      final figureRect = figure.rect;

      // Calculate scale to render at a reasonable resolution
      final targetWidth = 1000.0; // Target width for full page render
      final scale = targetWidth / ocrPageWidth;

      // Calculate the scaled dimensions
      final scaledPageWidth = (ocrPageWidth * scale);
      final scaledPageHeight = (ocrPageHeight * scale);

      // Calculate the figure position and size in the scaled coordinates
      final scaledX = (figureRect.left * scale).toInt();
      final scaledY = (figureRect.top * scale).toInt();
      final scaledWidth = (figureRect.width * scale).toInt();
      final scaledHeight = (figureRect.height * scale).toInt();

      // Render the sub-area of the page
      final renderResult = await page.render(
        x: scaledX,
        y: scaledY,
        width: scaledWidth,
        height: scaledHeight,
        fullWidth: scaledPageWidth,
        fullHeight: scaledPageHeight,
      );

      if (renderResult == null) {
        await document.dispose();
        return const Text('Failed to render page');
      }

      final image = await renderResult.createImage();

      // Clean up
      renderResult.dispose();
      await document.dispose();

      if (image != null) {
        return InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: RawImage(image: image, fit: BoxFit.contain),
        );
      }

      return const Text('Failed to create image');
    } catch (e) {
      return Text('Error: $e');
    }
  }
}

// Custom overlay widget for the figure popup with pin
class _FigurePopupOverlay extends StatefulWidget {
  final BaseLayout figure;
  final BasePage figurePage;
  final Offset targetPosition;
  final VoidCallback onClose;
  final Future<Widget> Function(int, BaseLayout) renderFigure;

  const _FigurePopupOverlay({
    required this.figure,
    required this.figurePage,
    required this.targetPosition,
    required this.onClose,
    required this.renderFigure,
  });

  @override
  State<_FigurePopupOverlay> createState() => _FigurePopupOverlayState();
}

class _FigurePopupOverlayState extends State<_FigurePopupOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    // Calculate popup size and position
    const popupWidth = 400.0;
    const popupHeight = 500.0;
    const pinHeight = 20.0;
    const margin = 20.0;

    // Determine if popup should appear above or below the target
    final showAbove = widget.targetPosition.dy > screenSize.height / 2;

    // Calculate popup position
    double popupLeft = widget.targetPosition.dx - popupWidth / 2;
    double popupTop =
        showAbove
            ? widget.targetPosition.dy - popupHeight - pinHeight - margin
            : widget.targetPosition.dy + margin;

    // Ensure popup stays within screen bounds
    popupLeft = popupLeft.clamp(margin, screenSize.width - popupWidth - margin);
    if (showAbove) {
      popupTop = popupTop.clamp(
        margin,
        screenSize.height - popupHeight - margin,
      );
    } else {
      popupTop = popupTop.clamp(
        margin,
        screenSize.height - popupHeight - margin,
      );
    }

    // Calculate pin position relative to popup
    final pinLeft =
        widget.targetPosition.dx - popupLeft - 10; // 10 is half of pin width

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            // Dimmed background
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  _animationController.reverse().then((_) => widget.onClose());
                },
                child: Container(
                  color: Colors.black.withOpacity(0.3 * _fadeAnimation.value),
                ),
              ),
            ),
            // Popup with pin
            Positioned(
              left: popupLeft,
              top: popupTop,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                alignment:
                    showAbove ? Alignment.bottomCenter : Alignment.topCenter,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!showAbove) _buildPin(theme, pinLeft),
                      Container(
                        width: popupWidth,
                        height: popupHeight,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Header
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceVariant,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.figure.caption ??
                                          'Figure ${widget.figure.figureNumber}',
                                      style: theme.textTheme.titleMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      _animationController.reverse().then(
                                        (_) => widget.onClose(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            // Figure content
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: FutureBuilder<Widget>(
                                  future: widget.renderFigure(
                                    widget.figurePage.pageIndex,
                                    widget.figure,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Error: ${snapshot.error}'),
                                      );
                                    }
                                    return snapshot.data ??
                                        const Text('Figure not available');
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (showAbove) _buildPin(theme, pinLeft),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPin(ThemeData theme, double pinLeft) {
    return SizedBox(
      width: 400, // Same as popup width
      height: 20,
      child: CustomPaint(
        painter: _PinPainter(
          color: theme.colorScheme.surface,
          shadowColor: Colors.black.withOpacity(0.2),
          pinPosition: pinLeft,
        ),
      ),
    );
  }
}

// Custom painter for the pin/arrow
class _PinPainter extends CustomPainter {
  final Color color;
  final Color shadowColor;
  final double pinPosition;

  _PinPainter({
    required this.color,
    required this.shadowColor,
    required this.pinPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final shadowPaint =
        Paint()
          ..color = shadowColor
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // Create pin path
    final path = Path();
    const pinWidth = 20.0;
    const pinHeight = 20.0;

    // Clamp pin position to ensure it stays within bounds
    final clampedPosition = pinPosition.clamp(
      10.0,
      size.width - pinWidth - 10.0,
    );

    path.moveTo(clampedPosition, 0);
    path.lineTo(clampedPosition + pinWidth, 0);
    path.lineTo(clampedPosition + pinWidth / 2, pinHeight);
    path.close();

    // Draw shadow
    canvas.drawPath(path, shadowPaint);
    // Draw pin
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
