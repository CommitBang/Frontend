import 'package:flutter/material.dart';

import '../../../shared/services/pdf_core/pdf_core.dart';
import '../models/pdf_viewer_view_model.dart';
import '../widgets/pdf_page_viewer.dart';
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
  final GlobalKey<PdfPageViewerState> _viewerKey =
      GlobalKey<PdfPageViewerState>();
  PdfViewerViewModel? _viewModel;

  @override
  void initState() {
    super.initState();

    // Get PDFProvider from InheritedWidget after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pdfProvider = InheritedPDFProviderWidget.of(context).provider;
      setState(() {
        _viewModel = PdfViewerViewModel(pdfProvider: pdfProvider);
      });

      // Listen for errors
      _viewModel!.addListener(_handleViewModelChanges);

      // Load initial PDF
      _viewModel!.loadPdf(path: widget.path, isAsset: widget.isAsset);
    });
  }

  void _handleViewModelChanges() {
    // Show error snackbar if there's an error
    if (_viewModel?.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _viewModel!.errorMessage!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
        );
        // Clear the error after showing
        _viewModel!.clearError();
      });
    }
  }

  void _onPageSelected(BasePage page) {
    // Jump to the selected page
    _viewerKey.currentState?.jumpToPage(page.pageIndex);
    _onPageChanged(page.pageIndex);
  }

  void _onLayoutSelected(BaseLayout layout) {
    // For layouts, we need to find which page contains this layout
    // and jump to that page
    if (_viewModel != null) {
      for (final page in _viewModel!.pages) {
        page.getLayouts().then((layouts) {
          if (layouts.contains(layout)) {
            _viewerKey.currentState?.jumpToPage(page.pageIndex);
            _onPageChanged(page.pageIndex);
          }
        });
      }
    }
  }

  void _onPageChanged(int pageIndex) {
    _viewModel?.updateCurrentPage(pageIndex);
  }

  void _onScaleChanged(double scale) {
    _viewModel?.updateZoom(scale);
  }

  @override
  void dispose() {
    _viewModel?.removeListener(_handleViewModelChanges);
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
        if (_viewModel!.document == null) {
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
                      child: PdfPageViewer(
                        key: _viewerKey,
                        document: _viewModel!.document!,
                        pages: _viewModel!.pages,
                        onScaleChanged: _onScaleChanged,
                        onPageChanged: _onPageChanged,
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
}
