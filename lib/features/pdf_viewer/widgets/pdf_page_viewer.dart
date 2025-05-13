//pdf_page_viewer.dart

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

/// PDF 문서의 모든 페이지를 스크롤 가능한 뷰로 렌더링하는 위젯
class PdfPageViewer extends StatelessWidget {
  final PdfDocument document;

  const PdfPageViewer({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final pages = document.pages;

    return ListView.builder(
      itemCount: pages.length,
      itemBuilder: (context, index) {
        final page = pages[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: AspectRatio(
            aspectRatio: page.width / page.height,
            child: PdfPageView(
              document: document,
              pageNumber: index,
            ),
          ),
        );
      },
    );
  }
}