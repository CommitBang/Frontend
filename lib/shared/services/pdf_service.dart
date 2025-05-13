//pdf_service.dart

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';

/// PDF 로드 서비스
/// - Asset, File, Bytes 경로 모두 지원
/// - 내부 캐시를 사용해 중복 로드 방지
class PdfService {
  // 싱글톤 패턴
  PdfService._();
  static final PdfService instance = PdfService._();

  // 로드된 문서 캐시
  final Map<String, PdfDocument> _cache = {};

  /// Assets 폴더에서 PDF 로드
  Future<PdfDocument> loadPdfFromAsset(String assetPath) async {
    if (_cache.containsKey(assetPath)) {
      return _cache[assetPath]!;
    }
    try {
      final doc = await PdfDocument.openAsset(assetPath);
      _cache[assetPath] = doc;
      return doc;
    } catch (e) {
      throw Exception('PDF 에셋 로드 실패: $assetPath, 오류: \$e');
    }
  }

  /// 로컬 파일 시스템에서 PDF 로드
  Future<PdfDocument> loadPdfFromFile(File file) async {
    final key = file.path;
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }
    try {
      final doc = await PdfDocument.openFile(key);
      _cache[key] = doc;
      return doc;
    } catch (e) {
      throw Exception('PDF 파일 로드 실패: \$key, 오류: \$e');
    }
  }

  /// 메모리 바이트에서 PDF 로드 (예: 네트워크 다운로드 후)
  Future<PdfDocument> loadPdfFromBytes(ByteData byteData, {String? cacheKey}) async {
    final key = cacheKey ?? byteData.hashCode.toString();
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }
    try {
      final doc = await PdfDocument.openData(byteData.buffer.asUint8List());
      _cache[key] = doc;
      return doc;
    } catch (e) {
      throw Exception('PDF 바이트 로드 실패: \$key, 오류: \$e');
    }
  }

  /// 캐시된 문서 삭제
  void clearCache([String? key]) {
    if (key != null) {
      _cache.remove(key);
    } else {
      _cache.clear();
    }
  }
}