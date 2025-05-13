import 'text_model.dart';

/// PDF OCR 예외 타입
enum PDFOCRExceptionType {
  invalidPDFPath,
  pdfLoadFailed,
  ocrFailed,
  duplicateProcess,
  renderPageFailed,
}

/// PDF OCR 예외 클래스
class PDFOCRException implements Exception {
  final String message;
  final PDFOCRExceptionType type;

  PDFOCRException(this.type, this.message);

  @override
  String toString() => message;
}

/// PDF 페이지 텍스트 데이터
class PDFPageTextData {
  /// 페이지 번호
  final int page;

  /// 텍스트 열 목록
  final List<TextColumnData> columns;

  /// 성공 여부
  final bool isSuccess;

  /// 예외 정보
  final PDFOCRException? exception;

  PDFPageTextData({
    required this.page,
    required this.columns,
    this.isSuccess = true,
    this.exception,
  });
}

/// PDF OCR 결과 클래스
class PDFOCRResult {
  /// PDF 경로
  final String pdfPath;

  /// 페이지 목록
  final List<PDFPageTextData> pages;

  PDFOCRResult({required this.pdfPath, required this.pages});
}

/// PDF OCR 처리 상태 타입
enum PDFOCRStatus {
  /// 초기화 중
  initializing,

  /// PDF 로드 중
  loadingPDF,

  /// OCR 처리 중
  processingOCR,

  /// 완료
  completed,

  /// 중단
  cancelled,

  /// 오류
  error,
}

/// PDF OCR 처리 상태
class PDFOCRProcessStatus {
  final PDFOCRStatus status;
  final double progress;
  final int currentPage;
  final int totalPage;

  PDFOCRProcessStatus({
    required this.status,
    required this.progress,
    required this.currentPage,
    required this.totalPage,
  });
}

/// PDF OCR 처리 프로세스 인터페이스
///
/// PDF에서 텍스트를 읽고 텍스트 데이터를 반환하는 프로세스를 정의합니다.
/// 해당 프로세스는 실행시 독립된 프로세스로 실행됩니다.
abstract class PDFOCRProcess {
  /// PDF 경로
  final String pdfPath;

  /// 언어 타입
  final LanguageType languageType;

  PDFOCRProcess({required this.pdfPath, required this.languageType});

  /// 처리 상태 스트림
  Stream<PDFOCRProcessStatus> get statusStream;

  /// PDF OCR 처리
  Future<PDFOCRResult> process();

  /// 처리 중단
  void cancel();
}
