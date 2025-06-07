// lib/shared/services/ocr_core/ocr_provider_impl.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:http/http.dart' as http;
import 'package:snapfig/shared/services/ocr_core/ocr_provider.dart';
import 'package:snapfig/shared/services/ocr_core/ocr_result.dart';

import 'package:path/path.dart' as path_lib;

class OCRProviderImpl extends OCRProvider {
  final String baseUrl;
  final http.Client httpClient;

  OCRProviderImpl({required this.baseUrl, http.Client? httpClient})
    : httpClient = httpClient ?? http.Client();

  @override
  Future<OCRResult> process(String pdfPath) async {
    // 1) 분석 요청
    final analyzeUri = Uri.parse('$baseUrl/analyze/pdf?format=frontend');
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
    if (analyzeRes.statusCode != 202) {
      throw Exception('OCR API 요청 실패: HTTP ${analyzeRes.statusCode}');
    }

    // 2) task_id, stream_url 파싱
    final bodyJson = json.decode(analyzeRes.body) as Map<String, dynamic>;
    final taskId = bodyJson['task_id'] as String;
    final streamUrl = '$baseUrl/analyze/stream/$taskId';

    // 3) SSE 구독: analyze/stream/{taskId}
    final completer = Completer<void>();
    // 먼저 선언
    late StreamSubscription<SSEModel> subscription;
    // 나중에 assign
    subscription = SSEClient.subscribeToSSE(
      method: SSERequestType.GET,
      url: streamUrl,
      header: {
        HttpHeaders.acceptHeader: 'text/event-stream',
        'Cache-Control': 'no-cache',
      },
    ).listen(
      (SSEModel event) {
        try {
          final data = json.decode(event.data ?? '{}') as Map<String, dynamic>;
          if (data['status'] == 'completed') {
            subscription.cancel();
            if (!completer.isCompleted) completer.complete();
          }
        } catch (_) {}
      },
      onError: (err) {
        subscription.cancel();
        if (!completer.isCompleted) completer.completeError(err);
      },
    );
    // 완료를 기다림
    await completer.future;

    // 4) 결과 조회: GET /result/{taskId}
    final resultUri = Uri.parse('$baseUrl/result/$taskId');
    final resultRes = await httpClient.get(
      resultUri,
      headers: {HttpHeaders.acceptHeader: 'application/json'},
    );
    if (resultRes.statusCode != 200) {
      throw Exception('결과 조회 실패: HTTP ${resultRes.statusCode}');
    }

    // 5) JSON → 모델 매핑
    final resultJson = json.decode(resultRes.body) as Map<String, dynamic>;
    return OCRResult.fromJson(resultJson);
  }
}
