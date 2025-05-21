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
  List<String> _recentPaths = [];

  @override
  void initState() {
    super.initState();
    // 1) 비동기 초기화
    _initialize();
  }

  Future<void> _initialize() async {
    final futureDoc = PdfService.instance.loadPdfFromAsset('assets/sample.pdf');
    final recents = await PdfService.instance.getRecentPaths();
    // 2) 동기적 상태 반영
    setState(() {
      _pdfFuture = futureDoc;
      _recentPaths = recents;
    });
  }

  Future<void> _pickPdfFromDevice() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);

      // 1. 비동기 작업: PDF 로드(Future)와 최근 경로 불러오기
      final futureDoc = PdfService.instance.loadPdfFromFile(file);
      final recents = await PdfService.instance.getRecentPaths();

      // 2. 동기적 상태 갱신
      setState(() {
        _pdfFuture = futureDoc;
        _recentPaths = recents;
      });
    }
  }

  void _showRecentList() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView.separated(
          itemCount: _recentPaths.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, idx) {
            final path = _recentPaths[idx];
            final name = path.split(Platform.pathSeparator).last;
            return ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: Text(name),
              subtitle: Text(path, overflow: TextOverflow.ellipsis),
              // ↓ onTap 콜백을 async가 아닌 동기 함수로 바꿉니다.
              onTap: () {
                // 1) 시트 닫기 (동기)
                Navigator.pop(context);

                // 2) PDF 로드 Future만 미리 생성
                final futureDoc = PdfService.instance.loadPdfFromFile(File(path));

                // 3) setState는 동기적으로 수행
                setState(() {
                  _pdfFuture = futureDoc;
                });
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Recent PDFs',
            onPressed: _showRecentList,
          ),
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
            return Center(child: Text('PDF 로드 오류: ${snapshot.error}'));
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