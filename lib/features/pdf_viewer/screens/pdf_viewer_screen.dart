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
  const PdfViewerScreen({super.key});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen>
    with SingleTickerProviderStateMixin {
  late Future<PdfDocument> _pdfFuture;
  late TabController _tabController;

  final GlobalKey<PdfPageViewerState> _viewerKey = GlobalKey<PdfPageViewerState>();
  List<String> _recentPaths = [];
  List<PdfPageModel> _pages = [];
  List<PdfLayoutModel> _figures = [];
  String _searchQuery = '';
  bool _sidebarVisible = true;

  // 임시 상태: 확대율 및 현재 페이지
  double _zoomPercent = 100;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0)
      ..addListener(() => setState(() {}));

    _loadPdf(path: 'assets/sample_ocr_test.pdf', isAsset: true);
  }

  Future<void> _loadPdf({required String path, required bool isAsset}) async {
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
      _pdfFuture = Future.value(doc);
      _recentPaths = recents;
      _pages = model.getPages().cast<PdfPageModel>();
      _figures = _pages
          .expand((page) => page.getLayouts().whereType<PdfLayoutModel>())
          .toList();
      _currentPage = 1;
      _zoomPercent = 100;
    });
  }

  Future<void> _pickPdfFromDevice() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final pth = result.files.single.path!;
      await _loadPdf(path: pth, isAsset: false);
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
          return ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: Text(p.basename(path)),
            subtitle: Text(path, overflow: TextOverflow.ellipsis),
            onTap: () {
              Navigator.pop(context);
              _loadPdf(path: path, isAsset: false);
            },
          );
        },
      ),
    );
  }

  Future<void> _promptPageJump() async {
    final input = await showDialog<String>(
      context: context,
      builder: (_) {
        String txt = '';
        return AlertDialog(
          title: const Text('Go to page'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (v) => txt = v,
            decoration: const InputDecoration(hintText: 'Enter page number'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(context, txt), child: const Text('Go')),
          ],
        );
      },
    );
    if (input != null && input.isNotEmpty) {
      final num = int.tryParse(input);
      if (num != null && num > 0 && num <= _pages.length - 1) {
        _viewerKey.currentState?.jumpToPage(num);
        setState(() => _currentPage = num);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPages = _pages
        .where((p) => p.pageIndex > 0 && p.pageIndex.toString().contains(_searchQuery))
        .toList();

    final filteredFigures = _figures
        .where((f) => f.content.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        leading: IconButton(
          icon: Icon(_sidebarVisible ? Icons.chevron_right : Icons.chevron_left),
          onPressed: () => setState(() => _sidebarVisible = !_sidebarVisible),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: _showRecentList),
          IconButton(icon: const Icon(Icons.folder_open), onPressed: _pickPdfFromDevice),
        ],
      ),
      body: FutureBuilder<PdfDocument>(
        future: _pdfFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final doc = snap.data!;
          return Row(
            children: [
              // PDF 영역 + 하단 바를 Column으로 묶음
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    // 실제 PDF 뷰어
                    Expanded(
                      child: PdfPageViewer(
                        key: _viewerKey,
                        document: doc,
                        // (추후 scale/page 변경 콜백 연결)
                      ),
                    ),
                    // 하단 바
                    Container(
                      height: 48,
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 확대율
                          Text('${_zoomPercent.toInt()}%', style: Theme.of(context).textTheme.bodyMedium),
                          // 페이지 표시
                          Text('$_currentPage / ${_pages.where((p) => p.pageIndex > 0).length}',
                              style: Theme.of(context).textTheme.bodyLarge),
                          // 페이지 점프 아이콘
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: _promptPageJump,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 사이드바
              if (_sidebarVisible)
                Container(
                  width: 260,
                  decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: Theme.of(context).dividerColor))),
                  child: Column(
                    children: [
                      // 탭 토글
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ToggleButtons(
                          isSelected: [_tabController.index == 0, _tabController.index == 1],
                          onPressed: (i) => _tabController.animateTo(i),
                          borderRadius: BorderRadius.circular(20),
                          selectedBorderColor: Theme.of(context).colorScheme.primary,
                          fillColor:
                          Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          selectedColor: Theme.of(context).colorScheme.primary,
                          color: Colors.grey,
                          constraints: const BoxConstraints(minWidth: 100, minHeight: 36),
                          children: const [Text('Page'), Text('Figure')],
                        ),
                      ),
                      // 리스트 본문
                      Expanded(
                        child: _tabController.index == 0
                            ? ListView.builder(
                          itemCount: filteredPages.length,
                          itemBuilder: (_, i) {
                            final page = filteredPages[i];
                            return ListTile(
                              leading: page.thumbnailWidget(width: 60, height: 80),
                              title: Text('Page ${page.pageIndex}'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                _viewerKey.currentState?.jumpToPage(page.pageIndex);
                                setState(() => _currentPage = page.pageIndex);
                              },
                            );
                          },
                        )
                            : ListView.builder(
                          itemCount: filteredFigures.length,
                          itemBuilder: (_, i) {
                            final fig = filteredFigures[i];
                            return ListTile(
                              leading:
                              fig.thumbnailWidget(width: 60, height: 60),
                              title: Text(
                                fig.content,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () =>
                                  _viewerKey.currentState?.jumpToPage(fig.pageIndex),
                            );
                          },
                        ),
                      ),
                      // 검색창
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText:
                            _tabController.index == 0 ? 'Search Page' : 'Search Figure',
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
                          onChanged: (v) => setState(() {
                            _searchQuery = v;
                          }),
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