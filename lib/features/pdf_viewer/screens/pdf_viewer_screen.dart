// lib/features/pdf_viewer/screens/pdf_viewer_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';

import 'package:pdf_viewer/shared/services/pdf_service.dart';
import 'package:pdf_viewer/shared/services/pdf_core/models/pdf_document_model.dart';
import 'package:pdf_viewer/shared/services/pdf_core/models/pdf_page_model.dart';
import 'package:pdf_viewer/shared/services/pdf_core/models/pdf_layout_model.dart';
import 'package:pdf_viewer/features/pdf_viewer/widgets/pdf_page_viewer.dart';

/// 이제 경로(path)와 isAsset 정보를 생성자로 받습니다.
class PdfViewerScreen extends StatefulWidget {
  /// PDF 파일의 경로. 에셋이면 "assets/…" 형태, 로컬 파일이면 절대경로.
  final String path;

  /// [path]가 애셋인지(false면 로컬 파일) 구분합니다.
  final bool isAsset;

  const PdfViewerScreen({
    Key? key,
    required this.path,
    this.isAsset = false,
  }) : super(key: key);

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

  double _zoomPercent = 100;
  int _currentPage = 1;
  String _pdfTitle = 'PDF Viewer';

  List<PdfPageModel> _pageList = [];
  late List<GlobalKey> _pageKeys;

  @override
  void initState() {
    super.initState();

    // 탭 컨트롤러 초기화
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0)
      ..addListener(() => setState(() {}));

    // 생성자로 받은 경로/타입으로 PDF 로드
    _loadPdf(path: widget.path, isAsset: widget.isAsset);
  }

  Future<void> _loadPdf({
    required String path,
    required bool isAsset,
  }) async {
    // 1) 문서 로드
    final doc = isAsset
        ? await PdfService.instance.loadPdfFromAsset(path)
        : await PdfService.instance.loadPdfFromFile(File(path));

    // 2) 모델 변환
    final model = await PdfDocumentModel.fromDocument(
      doc,
      name: p.basename(path),
      filePath: path,
    );

    // 3) 최근 목록
    final recents = await PdfService.instance.getRecentPaths();

    // 4) 페이지 & 키 초기화
    final allPages = model.getPages().cast<PdfPageModel>();
    // index 0는 무시
    final pageList = allPages.where((p) => p.pageIndex > 0).toList();
    final keys = List.generate(pageList.length, (_) => GlobalKey());

    // 5) 상태 반영
    setState(() {
      _pdfFuture = Future.value(doc);
      _recentPaths = recents;
      _pages = allPages;
      _figures = allPages
          .expand((page) => page.getLayouts().whereType<PdfLayoutModel>())
          .toList();
      _currentPage = 1;
      _zoomPercent = 100;
      _pdfTitle = model.name;
      _pageList = pageList;
      _pageKeys = keys;
    });
  }

  /// 기기 로컬에서 PDF 선택
  Future<void> _pickPdfFromDevice() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      await _loadPdf(path: result.files.single.path!, isAsset: false);
    }
  }

  /// 최근 열어본 PDF 리스트 표시
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

  /// 하단바 “Go to page” 다이얼로그
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
      if (num != null && num > 0 && num < _pages.length) {
        // 뷰어 점프
        _viewerKey.currentState?.jumpToPage(num);
        // 프레임 뒤 사이드바 중앙 정렬
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _onPageChanged(num);
        });
      }
    }
  }

  /// 페이지 변경 시 하단 숫자, 사이드바 위치 업데이트
  void _onPageChanged(int pageIndex) {
    setState(() => _currentPage = pageIndex);
    final pos = _pageList.indexWhere((p) => p.pageIndex == pageIndex);
    if (pos != -1 && _pageKeys[pos].currentContext != null) {
      Scrollable.ensureVisible(
        _pageKeys[pos].currentContext!,
        duration: const Duration(milliseconds: 300),
        alignment: 0.5,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPages = _pageList
        .where((p) => p.pageIndex.toString().contains(_searchQuery))
        .toList();
    final filteredFigures = _figures
        .where((f) => f.content.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_pdfTitle),
        // 뒤로가기(홈) 버튼
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // 최근 문서
          IconButton(icon: const Icon(Icons.history), onPressed: _showRecentList),
          // 로컬 폴더 열기
          IconButton(icon: const Icon(Icons.folder_open), onPressed: _pickPdfFromDevice),
          // ─────────────────────────────────────
          // 사이드바 숨기기/보이기 버튼
          IconButton(
            icon: Icon(_sidebarVisible ? Icons.visibility_off : Icons.visibility),
            tooltip: _sidebarVisible ? 'Hide sidebar' : 'Show sidebar',
            onPressed: () => setState(() => _sidebarVisible = !_sidebarVisible),
          ),
          // ─────────────────────────────────────
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
              // PDF 뷰어
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(
                      child: PdfPageViewer(
                        key: _viewerKey,
                        document: doc,
                        onScaleChanged: (scale) =>
                            setState(() => _zoomPercent = (scale * 100).roundToDouble()),
                        onPageChanged: _onPageChanged,
                      ),
                    ),
                    // 하단바
                    Container(
                      height: 48,
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${_zoomPercent.toInt()}%',
                              style: Theme.of(context).textTheme.bodyMedium),
                          Text('$_currentPage / ${_pageList.length}',
                              style: Theme.of(context).textTheme.bodyLarge),
                          IconButton(
                            icon: const Icon(Icons.search),
                            tooltip: 'Go to page',
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
                    border: Border(left: BorderSide(color: Theme.of(context).dividerColor)),
                  ),
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
                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          selectedColor: Theme.of(context).colorScheme.primary,
                          color: Colors.grey,
                          constraints: const BoxConstraints(minWidth: 100, minHeight: 36),
                          children: const [Text('Page'), Text('Figure')],
                        ),
                      ),
                      // 리스트
                      Expanded(
                        child: _tabController.index == 0
                        // Page 목록
                            ? ListView.builder(
                          itemCount: filteredPages.length,
                          itemBuilder: (_, idx) {
                            final page = filteredPages[idx];
                            final originalIdx =
                            _pageList.indexWhere((p) => p.pageIndex == page.pageIndex);
                            return Container(
                              key: _pageKeys[originalIdx],
                              child: ListTile(
                                leading: page.thumbnailWidget(width: 60, height: 80),
                                title: Text('Page ${page.pageIndex}'),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  _viewerKey.currentState
                                      ?.jumpToPage(page.pageIndex);
                                  _onPageChanged(page.pageIndex);
                                },
                              ),
                            );
                          },
                        )
                        // Figure 목록
                            : ListView.builder(
                          itemCount: filteredFigures.length,
                          itemBuilder: (_, idx) {
                            final fig = filteredFigures[idx];
                            return ListTile(
                              leading: fig.thumbnailWidget(width: 60, height: 60),
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
                      // 검색바
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
                              onPressed: () => setState(() => _searchQuery = ''),
                            )
                                : null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            isDense: true,
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          ),
                          onChanged: (v) => setState(() => _searchQuery = v),
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