import 'dart:isolate';
import 'dart:math';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pdf_image_renderer/pdf_image_renderer.dart';
import 'package:snapfig/shared/services/pdf_ocr/interfaces/text_model.dart';
import '../interfaces/pdf_ocr.dart';

/// PDF 페이지 범위를 나타내는 타입 별칭
typedef PageRange = List<int>;

/// PDF OCR 처리 구현체
class PDFOCRProcessImpl extends PDFOCRProcess {
  // 상수 정의
  static const int _maxConcurrency = 4;
  static const int _minPage = 20;

  // 상태 관리
  final _statusController = StreamController<PDFOCRProcessStatus>.broadcast();
  final _isolates = <Isolate>[];
  final _receivePorts = <ReceivePort>[];
  final _sendPorts = <SendPort>[];

  // 처리 상태
  bool _isRunning = false;
  int _totalPage = 0;
  int _processedPage = 0;
  final _logger = Logger('PDFOCRProcessImpl');

  PDFOCRProcessImpl({required super.pdfPath, required super.languageType}) {
    _logger.info('PDF OCR Process initialized. (pdfPath: $pdfPath)');
  }

  @override
  Stream<PDFOCRProcessStatus> get statusStream => _statusController.stream;

  @override
  Future<PDFOCRResult> process() async {
    _validateProcessState();
    _initializeProcess();

    try {
      _totalPage = await _getTotalPages();
      final pageRanges = _groupPageRanges(_totalPage);
      final results = await _processPageRangesInParallel(pageRanges);
      return _createResult(results);
    } catch (e) {
      rethrow;
    } finally {
      _cleanupResources();
      _cleanupProcess();
    }
  }

  /// 프로세스 상태 검증
  void _validateProcessState() {
    if (_isRunning) {
      _logger.warning('PDFOCRProcess is already running');
      throw PDFOCRException(
        PDFOCRExceptionType.duplicateProcess,
        'PDFOCRProcess is already running',
      );
    }
  }

  /// 프로세스 초기화
  void _initializeProcess() {
    _isRunning = true;
    _updateStatus(PDFOCRStatus.initializing, 0, 0);
    _logger.info('PDFOCRProcess initialized. (isRunning: $_isRunning)');
  }

  /// PDF 파일의 총 페이지 수를 가져옵니다.
  Future<int> _getTotalPages() async {
    _logger.info('Getting total pages. (pdfPath: $pdfPath)');
    _updateStatus(PDFOCRStatus.loadingPDF, 0, 0);
    final pdf = PdfImageRenderer(path: pdfPath);
    bool isPDFOpened = false;
    try {
      await pdf.open();
      isPDFOpened = true;
      _logger.info('PDF opened. (pdfPath: $pdfPath)');
      final totalPages = await pdf.getPageCount();
      _updateStatus(PDFOCRStatus.loadingPDF, 0, totalPages);
      _logger.info('Total pages loaded. (totalPages: $totalPages)');
      return totalPages;
    } catch (e) {
      _logger.severe('Failed to load PDF. (error: $e)');
      throw PDFOCRException(
        PDFOCRExceptionType.pdfLoadFailed,
        'Failed to load PDF',
      );
    } finally {
      if (isPDFOpened) {
        await pdf.close();
      }
    }
  }

  /// 페이지 범위 병렬 처리
  Future<List<PDFPageTextData>> _processPageRangesInParallel(
    List<PageRange> pageRanges,
  ) async {
    _processedPage = 0;
    final results = await Future.wait(
      pageRanges.map((range) => _spawnIsolateForPageRange(range)),
    );
    _updateStatus(PDFOCRStatus.completed, _totalPage, _totalPage);
    _logger.info('Page ocr completed.');
    return results.expand((pages) => pages).toList();
  }

  /// 페이지 범위를 위한 isolate 생성
  Future<List<PDFPageTextData>> _spawnIsolateForPageRange(
    PageRange range,
  ) async {
    final receivePort = ReceivePort();
    _logger.info('Spawning isolate for page ocr.');
    final isolateToken = RootIsolateToken.instance; // 백그라운드 아이솔레이트 초기화
    final isolate = await Isolate.spawn(_processPageOCR, [
      pdfPath,
      range,
      languageType,
      receivePort.sendPort,
      isolateToken,
    ]);

    _isolates.add(isolate);
    _receivePorts.add(receivePort);

    _logger.info(
      'Waiting for ocr result from isolate. (range: ${range.first} - ${range.last})',
    );
    final pages = await receivePort.first as List<PDFPageTextData>;
    _logger.info(
      'Received ocr result from isolate. (pages: ${range.first} - ${range.last})',
    );

    _processedPage += pages.length;
    _updateStatus(PDFOCRStatus.processingOCR, _processedPage, _totalPage);

    return pages;
  }

  /// 결과 생성
  PDFOCRResult _createResult(List<PDFPageTextData> pages) {
    pages.sort((p1, p2) => p1.page.compareTo(p2.page));
    return PDFOCRResult(pdfPath: pdfPath, pages: pages);
  }

  /// 프로세스 정리
  void _cleanupProcess() {
    _isRunning = false;
    _totalPage = 0;
    _processedPage = 0;
    _updateStatus(PDFOCRStatus.completed, _processedPage, _totalPage);
    _logger.info('PDFOCRProcess cleaned up. (isRunning: $_isRunning)');
  }

  /// 상태 업데이트
  void _updateStatus(PDFOCRStatus status, int currentPage, int totalPage) {
    _statusController.add(
      PDFOCRProcessStatus(
        status: status,
        progress: totalPage > 0 ? currentPage / totalPage : 0,
        currentPage: currentPage,
        totalPage: totalPage,
      ),
    );
  }

  /// 페이지 범위 그룹화
  List<PageRange> _groupPageRanges(int totalPage) {
    final groups = <PageRange>[];
    final pagesPerGroup =
        _totalPage < _minPage
            ? _totalPage
            : (_totalPage / _maxConcurrency).ceil();

    for (var i = 0; i < totalPage; i += pagesPerGroup) {
      final remainingPages = totalPage - i;
      final groupSize = min(pagesPerGroup, remainingPages);
      groups.add(List.generate(groupSize, (index) => i + index + 1));
    }
    _logger.info('Page ranges grouped. (groupSize: $pagesPerGroup)');
    return groups;
  }

  @override
  void cancel() {
    _isRunning = false;
    _updateStatus(PDFOCRStatus.cancelled, _processedPage, _totalPage);
    _cleanupResources();
  }

  /// 리소스 정리
  void _cleanupResources() {
    _totalPage = 0;
    _processedPage = 0;

    for (final isolate in _isolates) {
      isolate.kill();
    }
    for (final port in _receivePorts) {
      port.close();
    }
    for (final port in _sendPorts) {
      port.send(null);
    }

    _isolates.clear();
    _receivePorts.clear();
    _sendPorts.clear();
  }

  /// 페이지 OCR 처리 (Isolate에서 실행)
  static Future<void> _processPageOCR(List<dynamic> args) async {
    final pdfPath = args[0] as String;
    final range = args[1] as PageRange;
    final languageType = args[2] as LanguageType;
    final sendPort = args[3] as SendPort;
    final isolateToken = args[4] as RootIsolateToken;
    BackgroundIsolateBinaryMessenger.ensureInitialized(isolateToken);

    final pdf = PdfImageRenderer(path: pdfPath);
    await pdf.open();

    final textRecognizer = _createTextRecognizer(languageType);
    final results = await _processPages(pdf, textRecognizer, range);
    await textRecognizer.close();

    sendPort.send(results);
    await pdf.close();
  }

  /// 텍스트 인식기 생성
  static TextRecognizer _createTextRecognizer(LanguageType languageType) {
    return TextRecognizer(
      script: switch (languageType) {
        LanguageType.english => TextRecognitionScript.latin,
        LanguageType.korean => TextRecognitionScript.korean,
        LanguageType.uknown => TextRecognitionScript.latin,
      },
    );
  }

  /// 페이지 처리
  static Future<List<PDFPageTextData>> _processPages(
    PdfImageRenderer pdf,
    TextRecognizer textRecognizer,
    PageRange range,
  ) async {
    final results = <PDFPageTextData>[];

    for (final pageIndex in range) {
      try {
        final pageData = await _processPage(pdf, textRecognizer, pageIndex);
        results.add(pageData);
      } catch (e) {
        results.add(_createErrorPageData(pageIndex, e));
      }
    }

    return results;
  }

  /// 단일 페이지 처리
  static Future<PDFPageTextData> _processPage(
    PdfImageRenderer pdf,
    TextRecognizer textRecognizer,
    int pageIndex,
  ) async {
    await pdf.openPage(pageIndex: pageIndex - 1);
    final pageSize = await pdf.getPageSize(pageIndex: pageIndex - 1);

    final int imageScale = 3;
    final pageImg = await pdf.renderPage(
      pageIndex: pageIndex - 1,
      x: 0,
      y: 0,
      width: pageSize.width,
      height: pageSize.height,
      scale: imageScale.toDouble(),
    );
    await pdf.closePage(pageIndex: pageIndex - 1);

    if (pageImg == null) {
      return _createErrorPageData(
        pageIndex,
        PDFOCRException(
          PDFOCRExceptionType.renderPageFailed,
          'Failed to render page',
        ),
      );
    }

    final inputImage = InputImage.fromBitmap(
      bitmap: pageImg,
      width: pageSize.width * imageScale,
      height: pageSize.height * imageScale,
    );
    final recognizedText = await textRecognizer.processImage(inputImage);

    return PDFPageTextData(
      page: pageIndex + 1,
      columns:
          recognizedText.blocks
              .map((block) => _convertTextBlockToTextColumnData(block))
              .toList(),
    );
  }

  /// 에러 페이지 데이터 생성
  static PDFPageTextData _createErrorPageData(int pageIndex, dynamic error) {
    return PDFPageTextData(
      page: pageIndex + 1,
      columns: [],
      isSuccess: false,
      exception: PDFOCRException(
        PDFOCRExceptionType.ocrFailed,
        error.toString(),
      ),
    );
  }

  /// 텍스트 블록을 컬럼 데이터로 변환
  static TextColumnData _convertTextBlockToTextColumnData(TextBlock block) {
    return TextColumnData(
      text: block.text,
      rect: block.boundingBox,
      lines:
          block.lines
              .map((line) => _convertTextLineToTextLineData(line))
              .toList(),
    );
  }

  /// 텍스트 라인을 라인 데이터로 변환
  static LineData _convertTextLineToTextLineData(TextLine line) {
    return LineData(
      text: line.text,
      rect: line.boundingBox,
      confidence: line.confidence ?? 0,
      words:
          line.elements
              .map(
                (word) => WordData(
                  text: word.text,
                  rect: word.boundingBox,
                  confidence: word.confidence ?? 0,
                  languages:
                      word.recognizedLanguages
                          .map((code) => LanguageTypeExtension.fromString(code))
                          .toList(),
                ),
              )
              .toList(),
    );
  }
}
