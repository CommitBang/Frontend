import 'package:snapfig/shared/services/ocr_core/ocr_result.dart';

abstract class OCRProvider {
  // OCR 처리 메서드
  Future<OCRResult> process(String pdfPath);

  OCRProvider();
}
