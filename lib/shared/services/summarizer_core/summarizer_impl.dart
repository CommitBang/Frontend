import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:snapfig/shared/services/summarizer_core/summarizer.dart';

class SummarizerImpl extends Summarizer {
  final String baseUrl;
  final http.Client httpClient;

  SummarizerImpl({required this.baseUrl, http.Client? httpClient})
    : httpClient = httpClient ?? http.Client();

  @override
  Future<String> summarizeText(String text) async {
    final uri = Uri.parse('$baseUrl/api/v1/summarize/text');

    try {
      final response = await httpClient.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'text': text}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        final summaries = responseData['summaries'] as List<dynamic>;

        // Concatenate all summaries into a single string
        final summarizedText = summaries
            .map((item) => item['summary'] as String)
            .join('\n\n');

        return summarizedText;
      } else if (response.statusCode == 400) {
        throw Exception('Invalid request: text field is missing.');
      } else if (response.statusCode == 503) {
        throw Exception('Service unavailable');
      } else {
        throw Exception('API request failed: HTTP ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error: $e');
    }
  }

  @override
  Future<String> summarizeFigure(String pdfPath, String xref) async {
    final uri = Uri.parse('$baseUrl/api/v1/summarize/figure');
    
    // Extract filename from path
    final pdfFilename = path.basename(pdfPath);
    
    try {
      final response = await httpClient.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'pdf_filename': pdfFilename,
          'xref': int.tryParse(xref) ?? xref,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        return responseData['summary'] as String;
      } else if (response.statusCode == 400) {
        throw Exception('pdf_filename 또는 xref 필드가 누락되었습니다.');
      } else if (response.statusCode == 500) {
        throw Exception('도표 요약 처리 실패');
      } else {
        throw Exception('도표 요약 API 요청 실패: HTTP ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('도표 요약 중 오류 발생: $e');
    }
  }
}
