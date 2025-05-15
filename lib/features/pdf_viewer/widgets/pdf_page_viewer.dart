//pdf_page_viewer.dart

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// PDF 문서의 모든 페이지를 스크롤 가능한 뷰로 렌더링하는 위젯
/// 사용자가 각 페이지를 수직으로 스크롤
/// 사용자가 핀치 제스쳐로 확대/축소 할 수 있는 뷰어
class PdfPageViewer extends StatefulWidget {
  final PdfDocument document;

  const PdfPageViewer({super.key, required this.document});

  @override
  State<PdfPageViewer> createState() => _PdfPageViewerState();
}

class _PdfPageViewerState extends State<PdfPageViewer> {
  late PageController _pageController;
  late TransformationController _transformationController;
  late vm.Vector3 _lastTranslate;
  double _currentScale = 1.0;
  final double _minScale = 1.0;
  final double _maxScale = 4.0;

  bool _fitWidth = false;   // 가로 맞춤 모드
  bool _fitHeight = false;  // 세로 맞춤 모드

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 1, // 기본 페이지를 두 번째(인덱스 1)로 설정
    );
    _transformationController = TransformationController();
    _lastTranslate = vm.Vector3.zero();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  /// 확대 버튼 동작: 확대 전 위치 저장 후 스케일 유지
  void _zoomIn() {
    _lastTranslate = _transformationController.value.getTranslation();
    setState(() {
      _currentScale = (_currentScale + 0.5).clamp(_minScale, _maxScale);
      _transformationController.value = Matrix4.identity()
        ..translate(_lastTranslate.x, _lastTranslate.y)
        ..scale(_currentScale);
    });
  }

  /// 축소 버튼 동작: 축소 전 위치 저장 후 스케일 유지
  void _zoomOut() {
    _lastTranslate = _transformationController.value.getTranslation();
    setState(() {
      _currentScale = (_currentScale - 0.5).clamp(_minScale, _maxScale);
      _transformationController.value = Matrix4.identity()
        ..translate(_lastTranslate.x, _lastTranslate.y)
        ..scale(_currentScale);
    });
  }

  /// 중앙 정렬 버튼 동작: 현재 스케일 유지하며 오프셋 초기화
  void _resetAlignment() {
    setState(() {
      _transformationController.value = Matrix4.identity()
        ..scale(_currentScale);
    });
  }

  /// 가로 맞춤 아이콘 동작: 가로 맞춤 모드 토글
  void _toggleFitWidth() {
    setState(() {
      _fitWidth = true;
      _fitHeight = false;
    });
  }

  /// 세로 맞춤 아이콘 동작: 세로 맞춤 모드 토글
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
        // 페이지 단위 수직 스크롤 뷰
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: pageCount,
          itemBuilder: (context, index) {
            final page = widget.document.pages[index];
            return LayoutBuilder(
              builder: (context, constraints) {
                // 화면 전체를 사용하여 PDF를 박스에 맞춰 스케일링
                return InteractiveViewer(
                  constrained: false, // 자식 크기 자유 설정
                  transformationController: _transformationController,
                  panEnabled: true,  // 패닝 허용
                  scaleEnabled: true, // 확대/축소 허용
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
                        // PDF 페이지 렌더링
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
        // 확대/축소 및 중앙 정렬, 피팅 모드 버튼
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