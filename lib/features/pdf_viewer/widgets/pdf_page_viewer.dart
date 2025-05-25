// lib/features/pdf_viewer/widgets/pdf_page_viewer.dart

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// PDF 문서를 화면에 렌더링하고
/// - 수직 스크롤
/// - 핀치 제스처 확대/축소
/// - 외부에서 페이지 점프 기능 제공
class PdfPageViewer extends StatefulWidget {
  final PdfDocument document;

  // super.key 축약 문법 사용
  const PdfPageViewer({super.key, required this.document});

  /// 다른 위젯에서 페이지 점프 메서드를 호출할 때 사용합니다.
  /// public State 클래스(PdfPageViewerState)를 반환하도록 변경했습니다.
  static PdfPageViewerState? of(BuildContext context) {
    return context.findAncestorStateOfType<PdfPageViewerState>();
  }

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
    // 1번 페이지부터 시작
    _pageController = PageController(initialPage: 1);
    _transformationController = TransformationController();
    _lastTranslate = vm.Vector3.zero();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  /// 외부에서 호출 가능한 메서드: 특정 페이지로 즉시 이동
  void jumpToPage(int pageIndex) {
    _pageController.jumpToPage(pageIndex);
  }

  void _zoomIn() {
    _lastTranslate = _transformationController.value.getTranslation();
    final newScale = (_currentScale + 0.5).clamp(_minScale, _maxScale);
    setState(() {
      _currentScale = newScale;
      _transformationController.value = Matrix4.identity()
        ..translate(_lastTranslate.x, _lastTranslate.y)
        ..scale(_currentScale);
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
    });
  }

  void _resetAlignment() {
    setState(() {
      _transformationController.value = Matrix4.identity()
        ..scale(_currentScale);
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
        // 수직 스크롤 가능한 페이지 뷰
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

        // 컨트롤 버튼들 (Zoom, Reset, Fit)
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