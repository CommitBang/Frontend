// lib/shared/services/ocr_core/ocr_provider_impl.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:snapfig/shared/services/ocr_core/ocr_provider.dart';
import 'package:snapfig/shared/services/ocr_core/ocr_result.dart';

/// ngrok 또는 서버 호스트 URL을 지정하여 OCR API를 호출합니다.
class OCRProviderImpl extends OCRProvider {
  /// API 서버의 베이스 URL (예: https://901b-39-115-116-188.ngrok-free.app)
  final String baseUrl;

  /// 추가 헤더가 필요한 경우 여기에 지정 (예: 인증 토큰)
  final Map<String, String>? defaultHeaders;

  OCRProviderImpl({required this.baseUrl, this.defaultHeaders});

  @override
  Future<OCRResult> process(
    String pdfPath, {
    bool frontendFormat = true,
  }) async {
    // 1) 분석 요청 (multipart/form-data + format 필드)
    final uri = Uri.parse('$baseUrl/analyze/pdf');
    final request =
        http.MultipartRequest('POST', uri)
          ..headers.addAll({'Accept': 'application/json', ...?defaultHeaders})
          // form-data 필드로 format 설정
          ..fields['format'] = frontendFormat ? 'frontend' : 'raw'
          ..files.add(
            await http.MultipartFile.fromPath(
              'file',
              pdfPath,
              filename: pdfPath.split(Platform.pathSeparator).last,
            ),
          );

    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode != 202) {
      throw Exception('OCR API 요청 실패: HTTP ${res.statusCode}');
    }

    // 2) Task ID 및 상태 조회 URL 파싱
    final Map<String, dynamic> taskData = json.decode(res.body);
    final String taskId = taskData['task_id'];
    final String statusPath = taskData['check_status_url'];

    // 3) 상태 완료될 때까지 폴링
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      final statusUri = Uri.parse('$baseUrl$statusPath');
      final statusRes = await http.get(statusUri, headers: request.headers);
      if (statusRes.statusCode != 200) {
        throw Exception('상태 조회 실패: HTTP ${statusRes.statusCode}');
      }
      final statusJson = json.decode(statusRes.body);
      if (statusJson['status'] == 'completed') break;
    }

    // 4) 결과 조회
    final resultUri = Uri.parse('$baseUrl/result/$taskId');
    final resultRes = await http.get(resultUri, headers: request.headers);
    if (resultRes.statusCode != 200) {
      throw Exception('결과 조회 실패: HTTP ${resultRes.statusCode}');
    }
    final Map<String, dynamic> jsonData = json.decode(resultRes.body);

    // 5) JSON → 모델 매핑
    return OCRResult.fromJson(jsonData);
  }
}
