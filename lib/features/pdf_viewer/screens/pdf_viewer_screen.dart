//pdf_viewer_screen.dart

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import '../../../shared/services/pdf_service.dart';
import '../widgets/pdf_page_viewer.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late Future<PdfDocument> _pdfFuture;

  @override
  void initState() {
    super.initState();
    _pdfFuture = PdfService.instance.loadPdfFromAsset('assets/sample.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: FutureBuilder<PdfDocument>(
        future: _pdfFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('PDF 로드 오류: \${snapshot.error}'));
          } else if (snapshot.hasData) {
            return PdfPageViewer(document: snapshot.data!);
          } else {
            return const Center(child: Text('PDF를 불러올 수 없습니다.'));
          }
        },
      ),
    );
  }
}
