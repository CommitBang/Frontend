//pdf_page_viewer.dart

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

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
  double _currentScale = 1.0;
  final double _minScale = 1.0;
  final double _maxScale = 4.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 1, // 기본 페이지를 두 번째(인덱스 1) 페이지로 설정
    );
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  /// 확대 버튼 동작
  void _zoomIn() {
    setState(() {
      _currentScale = (_currentScale + 0.5).clamp(_minScale, _maxScale);
      _transformationController.value = Matrix4.identity()..scale(_currentScale);
    });
  }

  /// 축소 버튼 동작
  void _zoomOut() {
    setState(() {
      _currentScale = (_currentScale - 0.5).clamp(_minScale, _maxScale);
      _transformationController.value = Matrix4.identity()..scale(_currentScale);
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
                  constrained: false,  // 자식 크기 자유 설정
                  transformationController: _transformationController,
                  panEnabled: true,  // 패닝 허용
                  scaleEnabled: true, // 확대/축소 허용
                  minScale: _minScale,
                  maxScale: _maxScale,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: FittedBox(
                      fit: BoxFit.contain,
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
        // 확대/축소 버튼
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
            ],
          ),
        ),
      ],
    );
  }
}