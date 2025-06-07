// lib/shared/services/ocr_core/ocr_provider.dart

import 'package:snapfig/shared/services/ocr_core/ocr_result.dart';

/// OCR 처리 인터페이스
abstract class OCRProvider {
  /// PDF 파일 경로를 받아 분석 결과를 반환
  /// [frontendFormat]이 true 면 서버에 `format=frontend` 로 요청합니다.
  Future<OCRResult> process(String pdfPath, {bool frontendFormat = true});
}
