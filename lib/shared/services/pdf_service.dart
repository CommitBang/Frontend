//pdf_service.dart

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfService {
  PdfService._();
  static final PdfService instance = PdfService._();

  final Map<String, PdfDocument> _cache = {};

  static const _recentKey = 'recent_pdf_paths';
  static const _maxRecent = 10;

  /// Asset에서 로드
  Future<PdfDocument> loadPdfFromAsset(String assetPath) async {
    final doc = _cache[assetPath] ??= await PdfDocument.openAsset(assetPath);
    await _addRecent(assetPath);
    return doc;
  }

  /// 파일 시스템에서 로드
  Future<PdfDocument> loadPdfFromFile(File file) async {
    final key = file.path;
    final doc = _cache[key] ??= await PdfDocument.openFile(key);
    await _addRecent(key);
    return doc;
  }

  /// 바이트로 로드
  Future<PdfDocument> loadPdfFromBytes(ByteData data, {String? cacheKey}) async {
    final key = cacheKey ?? data.hashCode.toString();
    final doc = _cache[key] ??= await PdfDocument.openData(data.buffer.asUint8List());
    await _addRecent(key);
    return doc;
  }

  /// 캐시 초기화
  void clearCache([String? key]) {
    if (key != null) _cache.remove(key);
    else _cache.clear();
  }

  // ─────────────────────────────────────
  // 아래는 “최근 파일 관리” 기능
  // ─────────────────────────────────────

  /// 최근 열었던 PDF 경로 리스트 가져오기
  Future<List<String>> getRecentPaths() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_recentKey) ?? [];
  }

  /// 경로를 최근 목록으로 추가 (중복 제거, 최대 _maxRecent 유지)
  Future<void> _addRecent(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_recentKey) ?? <String>[];
    list.remove(path);
    list.insert(0, path);
    if (list.length > _maxRecent) list.removeLast();
    await prefs.setStringList(_recentKey, list);
  }

  /// 최근 목록 초기화
  Future<void> clearRecentPaths() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentKey);
  }
}