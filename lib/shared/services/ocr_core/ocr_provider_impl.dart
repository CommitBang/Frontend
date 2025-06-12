// lib/shared/services/ocr_core/ocr_provider_impl.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:snapfig/shared/services/ocr_core/ocr_provider.dart';
import 'package:snapfig/shared/services/ocr_core/models/ocr_result.dart';

import 'package:path/path.dart' as path_lib;

class OCRProviderImpl extends OCRProvider {
  final String baseUrl;
  final http.Client httpClient;

  OCRProviderImpl({required this.baseUrl, http.Client? httpClient})
    : httpClient = httpClient ?? _createHttpClient();

  static http.Client _createHttpClient() {
    final httpClient = HttpClient();
    httpClient.badCertificateCallback = (cert, host, port) => true;
    return IOClient(httpClient);
  }

  @override
  Future<OCRResult> process(String pdfPath) async {
    // 1) 분석 요청
    final analyzeUri = Uri.parse('$baseUrl/api/v1/analyze');
    final pdfBytes = await File(pdfPath).readAsBytes();
    final request = http.MultipartRequest('POST', analyzeUri)
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          pdfBytes,
          filename: path_lib.basename(pdfPath),
        ),
      );
    final response = await httpClient.send(request);
    final analyzeRes = await http.Response.fromStream(response);
    if (analyzeRes.statusCode != 200) {
      throw Exception('OCR API 요청 실패: HTTP ${analyzeRes.statusCode}');
    }
    final bodyJson = json.decode(analyzeRes.body) as Map<String, dynamic>;
    return OCRResult.fromJson(bodyJson);
  }
}
