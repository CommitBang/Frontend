// lib/features/pdf_viewer/widgets/pdf_page_viewer.dart

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// PDF 문서를 화면에 렌더링하고
/// - 수직 스크롤
/// - 핀치 제스처 확대/축소
/// - 외부에서 페이지 점프 기능 제공
/// - 확대율 및 페이지 변경 콜백
class PdfPageViewer extends StatefulWidget {
  final PdfDocument document;
  final ValueChanged<double>? onScaleChanged;
  final ValueChanged<int>? onPageChanged;

  const PdfPageViewer({
    super.key,
    required this.document,
    this.onScaleChanged,
    this.onPageChanged,
  });

  static PdfPageViewerState? of(BuildContext context) =>
      context.findAncestorStateOfType<PdfPageViewerState>();

  @override
  PdfPageViewerState createState() => PdfPageViewerState();
}

class PdfPageViewerState extends State<PdfPageViewer> {
  late final PageController _pageController;
  late final TransformationController _transformationController;
  late vm.Vector3 _lastTranslate;
  double _currentScale = 1.0;
  final double _minScale = 1.0;
  final double _maxScale = 4.0;

  bool _fitWidth = false;
  bool _fitHeight = false;

  @override
  void initState() {
    super.initState();
    // 첫 페이지를 1으로 설정
    _pageController = PageController(initialPage: 1)
      ..addListener(() {
        final page = (_pageController.page ?? 1).round();
        widget.onPageChanged?.call(page);
      });
    _transformationController = TransformationController();
    _lastTranslate = vm.Vector3.zero();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  /// 외부에서 호출할 수 있도록 페이지 점프 메서드 공개
  void jumpToPage(int pageIndex) {
    _pageController.jumpToPage(pageIndex);
  }

  void _notifyScale() {
    widget.onScaleChanged?.call(_currentScale);
  }

  void _zoomIn() {
    _lastTranslate = _transformationController.value.getTranslation();
    final newScale = (_currentScale + 0.5).clamp(_minScale, _maxScale);
    setState(() {
      _currentScale = newScale;
      _transformationController.value = Matrix4.identity()
        ..translate(_lastTranslate.x, _lastTranslate.y)
        ..scale(_currentScale);
      _notifyScale();
    });
  }

  void _zoomOut() {
    _lastTranslate = _transformationController.value.getTranslation();
    final newScale = (_currentScale - 0.5).clamp(_minScale, _maxScale);
    setState(() {
      _currentScale = newScale;
      _transformationController.value = Matrix4.identity()
        ..translate(_lastTranslate.x, _lastTranslate.y)
        ..scale(_currentScale);
      _notifyScale();
    });
  }

  void _resetAlignment() {
    setState(() {
      _transformationController.value =
      Matrix4.identity()..scale(_currentScale);
      _notifyScale();
    });
  }

  void _toggleFitWidth() {
    setState(() {
      _fitWidth = true;
      _fitHeight = false;
    });
  }

  void _toggleFitHeight() {
    setState(() {
      _fitWidth = false;
      _fitHeight = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageCount = widget.document.pages.length;

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: pageCount,
          itemBuilder: (context, index) {
            final page = widget.document.pages[index];
            return LayoutBuilder(
              builder: (context, constraints) {
                return InteractiveViewer(
                  constrained: false,
                  transformationController: _transformationController,
                  panEnabled: true,
                  scaleEnabled: true,
                  minScale: _minScale,
                  maxScale: _maxScale,
                  onInteractionEnd: (_) => _notifyScale(),
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: FittedBox(
                      fit: _fitWidth
                          ? BoxFit.fitWidth
                          : _fitHeight
                          ? BoxFit.fitHeight
                          : BoxFit.contain,
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: page.width,
                        height: page.height,
                        child: PdfPageView(
                          document: widget.document,
                          pageNumber: index,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),

        Positioned(
          top: 16,
          right: 16,
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: _zoomIn,
                mini: true,
                child: const Icon(Icons.zoom_in),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                onPressed: _zoomOut,
                mini: true,
                child: const Icon(Icons.zoom_out),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                onPressed: _resetAlignment,
                mini: true,
                child: const Icon(Icons.center_focus_strong),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                onPressed: _toggleFitWidth,
                mini: true,
                child: const Icon(Icons.swap_horiz),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                onPressed: _toggleFitHeight,
                mini: true,
                child: const Icon(Icons.swap_vert),
              ),
            ],
          ),
        ),
      ],
    );
  }
}