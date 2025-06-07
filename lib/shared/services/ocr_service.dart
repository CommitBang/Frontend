import 'package:snapfig/shared/services/ocr_core/ocr_core.dart';

class OCRService {
  static const _baseUrl = 'https://901b-39-115-116-188.ngrok-free.app';

  final OCRProviderImpl _provider = OCRProviderImpl(
    baseUrl: _baseUrl,
    // 필요하다면 여기 토큰 등 헤더 추가
    // defaultHeaders: {'Authorization': 'Bearer <token>'},
  );

  /// PDF 파일 경로를 넘겨서 분석 결과를 받습니다.
  Future<OCRResult> analyzePdf(String pdfPath) {
    return _provider.process(pdfPath, frontendFormat: true);
  }
}
