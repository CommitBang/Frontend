// lib/features/pdf_viewer/screens/pdf_viewer_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';

import 'package:pdf_viewer/shared/services/pdf_service.dart';
import 'package:pdf_viewer/shared/services/pdf_core/models/pdf_document_model.dart';
import 'package:pdf_viewer/shared/services/pdf_core/models/pdf_page_model.dart';
import 'package:pdf_viewer/shared/services/pdf_core/models/pdf_layout_model.dart';
import 'package:pdf_viewer/features/pdf_viewer/widgets/pdf_page_viewer.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({Key? key}) : super(key: key);

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen>
    with SingleTickerProviderStateMixin {
  late Future<PdfDocument> _pdfFuture;
  late TabController _tabController;

  // GlobalKey로 PdfPageViewer 상태에 직접 접근
  final GlobalKey<PdfPageViewerState> _viewerKey = GlobalKey<PdfPageViewerState>();

  List<String> _recentPaths = [];
  List<PdfPageModel> _pages = [];
  List<PdfLayoutModel> _figures = [];

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0)
      ..addListener(() => setState(() {}));

    _pdfFuture = PdfService.instance.loadPdfFromAsset('assets/sample_ocr_test.pdf'); /// sample.pdf 진입점
    _loadPdf(path: 'assets/sample_ocr_test.pdf', isAsset: true);
  }

  Future<void> _loadPdf({
    required String path,
    required bool isAsset,
  }) async {
    final doc = isAsset
        ? await PdfService.instance.loadPdfFromAsset(path)
        : await PdfService.instance.loadPdfFromFile(File(path));

    final model = await PdfDocumentModel.fromDocument(
      doc,
      name: p.basename(path),
      filePath: path,
    );
    final recents = await PdfService.instance.getRecentPaths();

    setState(() {
      _recentPaths = recents;
      _pages = model.getPages().cast<PdfPageModel>();
      _figures = _pages
          .expand((page) => page.getLayouts().whereType<PdfLayoutModel>())
          .toList();
      _searchQuery = '';
      /// ★ 여기가 핵심: FutureBuilder 가 바라보는 Future 도 갱신
      _pdfFuture = Future.value(doc); ///
    });
  }

  Future<void> _pickPdfFromDevice() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      setState(() {
        _pdfFuture = PdfService.instance.loadPdfFromFile(File(path));
      });
      await _loadPdf(path: path, isAsset: false);
    }
  }

  void _showRecentList() {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.separated(
        itemCount: _recentPaths.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, idx) {
          final path = _recentPaths[idx];
          final name = p.basename(path);
          return ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: Text(name),
            subtitle: Text(path, overflow: TextOverflow.ellipsis),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _pdfFuture =
                    PdfService.instance.loadPdfFromFile(File(path));
              });
              _loadPdf(path: path, isAsset: false);
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 페이지 인덱스 0은 건너뛰고, 실제 사용자용 번호(1부터) 필터링
    final pageList = _pages.where((p) => p.pageIndex > 0).toList();
    final filteredPages = pageList
        .where((p) => p.pageIndex.toString().contains(_searchQuery))
        .toList();

    final filteredFigures = _figures
        .where((f) =>
        f.content.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

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
          }
          if (snapshot.hasError) {
            return Center(child: Text('PDF 로드 오류: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('PDF를 불러올 수 없습니다.'));
          }

          return Row(
            children: [
              // 1) PDF 뷰어
              Expanded(
                flex: 3,
                child: PdfPageViewer(
                  key: _viewerKey,
                  document: snapshot.data!,
                ),
              ),

              // 2) 사이드바 (Page / Figure)
              Container(
                width: 240,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                ),
                child: Column(
                  children: [
                    // 탭 토글
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ToggleButtons(
                        isSelected: [
                          _tabController.index == 0,
                          _tabController.index == 1
                        ],
                        onPressed: (i) => _tabController.animateTo(i),
                        borderRadius: BorderRadius.circular(8),
                        selectedBorderColor:
                        Theme.of(context).colorScheme.primary,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        selectedColor:
                        Theme.of(context).colorScheme.primary,
                        color: Colors.grey,
                        constraints: const BoxConstraints(
                            minWidth: 100, minHeight: 36),
                        children: const [
                          Text('Page'),
                          Text('Figure'),
                        ],
                      ),
                    ),

                    // 검색창 및 리스트
                    Expanded(
                      child: Column(
                        children: [
                          // 검색바
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: _tabController.index == 0
                                    ? 'Search Page'
                                    : 'Search Figure',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () =>
                                      setState(() => _searchQuery = ''),
                                )
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                              ),
                              onChanged: (v) =>
                                  setState(() => _searchQuery = v),
                            ),
                          ),

                          // Page / Figure 목록
                          Expanded(
                            child: _tabController.index == 0
                            // Page 탭: pageList 기준, 1부터 시작
                                ? ListView.builder(
                              itemCount: filteredPages.length,
                              itemBuilder: (_, idx) {
                                final page = filteredPages[idx];
                                return ListTile(
                                  leading: page
                                      .thumbnailWidget(width: 80, height: 110),
                                  title:
                                  Text('Page ${page.pageIndex}'),
                                  trailing:
                                  const Icon(Icons.chevron_right),
                                  onTap: () {
                                    _viewerKey.currentState
                                        ?.jumpToPage(page.pageIndex);
                                  },
                                );
                              },
                            )
                            // Figure 탭
                                : ListView.builder(
                              itemCount: filteredFigures.length,
                              itemBuilder: (_, idx) {
                                final fig = filteredFigures[idx];
                                return ListTile(
                                  leading: fig.thumbnailWidget(
                                      width: 60, height: 60),
                                  title: Text(
                                    fig.content,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    fig.type
                                        .toString()
                                        .split('.')
                                        .last,
                                  ),
                                  trailing:
                                  const Icon(Icons.chevron_right),
                                  onTap: () {
                                    _viewerKey.currentState
                                        ?.jumpToPage(fig.pageIndex);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}