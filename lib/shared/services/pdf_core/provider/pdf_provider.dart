import 'package:flutter/foundation.dart';
import 'package:snapfig/shared/services/pdf_core/models/models.dart';

// PDF를 관리하는 프로바이더 인터페이스
abstract class PDFProvider extends ChangeNotifier {
  /// 현재 PDF 리스트 (변경 시 notifyListeners)
  List<BasePdf> get pdfs;

  /// 파일 경로로부터 PDF 추가
  Future<void> addPDF(String filePath);

  /// PDF 삭제
  Future<void> deletePDF(BasePdf pdf);

  /// PDF 정보 업데이트
  Future<void> updatePDF(BasePdf pdf);

  /// 쿼리(필터 등)
  Future<List<BasePdf>> queryPDFs({String? keyword, PDFStatus? status});
}
