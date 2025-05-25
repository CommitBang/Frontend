import 'package:snapfig/shared/services/ocr_core/ocr_result.dart';
import 'package:snapfig/shared/services/pdf_core/models/models.dart';

abstract class OCRProvider {
  // OCR 처리 메서드
  Future<OCRResult> process(BasePdf pdf);

  OCRProvider();
}
