//pdf_page_viewer.dart

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

/// PDF 문서의 모든 페이지를 스크롤 가능한 뷰로 렌더링하는 위젯
/// 사용자가 각 페이지를 수직으로 스크롤
/// 사용자가 핀치 제스쳐로 확대/축소 할 수 있는 뷰어
class PdfPageViewer extends StatelessWidget {
  final PdfDocument document;

  const PdfPageViewer({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageCount = document.pages.length;

    return PageView.builder(
      scrollDirection: Axis.vertical,
      controller: PageController(initialPage: 1), //첫 페이지 번호 인덱스 (인덱스를 0으로 설정시 첫 화면이 배경으로 보임)
      itemCount: pageCount,
      itemBuilder: (context, index) {
        final page = document.pages[index];

        // 상단 정렬 → 페이지 맨 위(여백+컨텐츠 시작 부분)가 항상 화면 맨 위에 위치
        return Align(
          alignment: Alignment.topCenter,
          child: InteractiveViewer(
            panEnabled: true,
            scaleEnabled: true,
            minScale: 1.0, // 최소 스케일 값
            maxScale: 4.0, // 최대 스케일 값
            child: AspectRatio(
              aspectRatio: page.width / page.height,
              child: PdfPageView(
                document: document,
                pageNumber: index,
              ),
            ),
          ),
        );
      },
    );
  }
}