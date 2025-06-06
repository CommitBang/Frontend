// lib/shared/services/pdf_service.dart

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfService {
  PdfService._();
  static final PdfService instance = PdfService._();

  /// 마지막으로 로드된 PdfDocument를 추적합니다.
  PdfDocument? currentDocument;

  // 로드된 문서를 캐시에 저장하여 중복 로드 방지
  final Map<String, PdfDocument> _cache = {};

  static const _recentKey = 'recent_pdf_paths';
  static const _maxRecent = 10;

  /// Assets 폴더에서 PDF 로드
  Future<PdfDocument> loadPdfFromAsset(String assetPath) async {
    final doc = _cache[assetPath] ??= await PdfDocument.openAsset(assetPath);
    // 현재 문서 갱신
    currentDocument = doc;
    await _addRecent(assetPath);
    return doc;
  }

  /// 로컬 파일 시스템에서 PDF 로드
  Future<PdfDocument> loadPdfFromFile(File file) async {
    final key = file.path;
    final doc = _cache[key] ??= await PdfDocument.openFile(key);
    currentDocument = doc;
    await _addRecent(key);
    return doc;
  }

  /// 메모리 바이트에서 PDF 로드 (예: 네트워크 다운로드 후)
  Future<PdfDocument> loadPdfFromBytes(ByteData data, {String? cacheKey}) async {
    final key = cacheKey ?? data.hashCode.toString();
    final doc = _cache[key] ??= await PdfDocument.openData(data.buffer.asUint8List());
    currentDocument = doc;
    await _addRecent(key);
    return doc;
  }

  /// 캐시된 문서를 삭제하거나 전체 캐시를 초기화
  void clearCache([String? key]) {
    if (key != null) {
      _cache.remove(key);
    } else {
      _cache.clear();
    }
    // currentDocument는 남겨둘 수도 있고, 필요시 null로 만들 수도 있습니다.
  }

  // ─────────────────────────────────────
  // “최근 파일 관리” 기능
  // ─────────────────────────────────────

  /// 최근 열었던 PDF 경로 리스트 반환
  Future<List<String>> getRecentPaths() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_recentKey) ?? <String>[];
  }

  /// 경로를 최근 목록으로 추가 (중복 제거, 최대 _maxRecent 유지)
  Future<void> _addRecent(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_recentKey) ?? <String>[];
    list.remove(path);
    list.insert(0, path);
    if (list.length > _maxRecent) {
      list.removeLast();
    }
    await prefs.setStringList(_recentKey, list);
  }

  /// 최근 목록 전체 삭제
  Future<void> clearRecentPaths() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentKey);
  }
}