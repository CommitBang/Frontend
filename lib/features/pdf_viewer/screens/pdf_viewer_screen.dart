//pdf_viewer_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:pdf_viewer/shared/services/pdf_service.dart';
import 'package:pdf_viewer/features/pdf_viewer/widgets/pdf_page_viewer.dart';
import 'package:file_picker/file_picker.dart';

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
    // 기본: assets/sample.pdf 불러오기
    _pdfFuture = PdfService.instance.loadPdfFromAsset('assets/sample.pdf');
  }

  // 기기 저장소에서 PDF 선택
  Future<void> _pickPdfFromDevice() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      setState(() {
        _pdfFuture = PdfService.instance.loadPdfFromFile(file);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open),
            tooltip: 'Load from device',
            onPressed: _pickPdfFromDevice,
          ),
        ],
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