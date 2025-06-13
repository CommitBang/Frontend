import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:snapfig/shared/services/summarizer_core/summarizer_core.dart';
import 'dart:convert';

void main() {
  group('SummarizerImpl', () {
    late Summarizer summarizer;
    late MockClient mockClient;
    const baseUrl = 'https://test-api.example.com';

    setUp(() {
      mockClient = MockClient((request) async {
        if (request.url.path == '/api/v1/summarize/text' &&
            request.method == 'POST') {
          final body = json.decode(request.body) as Map<String, dynamic>;

          if (!body.containsKey('text')) {
            return http.Response('{"error": "Missing text field"}', 400);
          }

          return http.Response(
            json.encode({
              'summaries': [
                {
                  'original': 'The first original paragraph',
                  'summary': 'The first summarized paragraph.',
                },
                {
                  'original': 'The second original paragraph',
                  'summary': 'The second summarized paragraph.',
                },
              ],
            }),
            200,
          );
        }

        return http.Response('Not Found', 404);
      });

      summarizer = SummarizerImpl(baseUrl: baseUrl, httpClient: mockClient);
    });

    test('should successfully summarize text', () async {
      const inputText = 'Some long text that needs to be summarized';

      final result = await summarizer.summarizeText(inputText);

      expect(
        result,
        equals(
          'The first summarized paragraph.\n\nThe second summarized paragraph.',
        ),
      );
    });

    test('should throw exception on 400 error', () async {
      mockClient = MockClient((request) async {
        return http.Response('{"error": "Missing text field"}', 400);
      });

      summarizer = SummarizerImpl(baseUrl: baseUrl, httpClient: mockClient);

      expect(
        () => summarizer.summarizeText('test'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('요청에 text 필드가 없습니다'),
          ),
        ),
      );
    });

    test('should throw exception on 503 error', () async {
      mockClient = MockClient((request) async {
        return http.Response('{"error": "Service unavailable"}', 503);
      });

      summarizer = SummarizerImpl(baseUrl: baseUrl, httpClient: mockClient);

      expect(
        () => summarizer.summarizeText('test'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('요약 처리 실패 (내부 서비스 오류)'),
          ),
        ),
      );
    });

    test('should successfully summarize figure', () async {
      mockClient = MockClient((request) async {
        if (request.url.path == '/api/v1/summarize/figure' && 
            request.method == 'POST') {
          final body = json.decode(request.body) as Map<String, dynamic>;
          
          if (!body.containsKey('pdf_filename') || !body.containsKey('xref')) {
            return http.Response('{"error": "Missing required fields"}', 400);
          }
          
          return http.Response(
            json.encode({
              'summary': 'This figure shows a bar chart representing sales data.',
            }),
            200,
          );
        }
        
        return http.Response('Not Found', 404);
      });
      
      summarizer = SummarizerImpl(baseUrl: baseUrl, httpClient: mockClient);
      
      final result = await summarizer.summarizeFigure('/path/to/example.pdf', '5');
      
      expect(result, equals('This figure shows a bar chart representing sales data.'));
    });

    test('summarizeFigure should throw exception on 400 error', () async {
      mockClient = MockClient((request) async {
        return http.Response('{"error": "Missing required fields"}', 400);
      });
      
      summarizer = SummarizerImpl(baseUrl: baseUrl, httpClient: mockClient);
      
      expect(
        () => summarizer.summarizeFigure('/path/to/pdf', '5'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('pdf_filename 또는 xref 필드가 누락되었습니다'),
          ),
        ),
      );
    });

    test('summarizeFigure should throw exception on 500 error', () async {
      mockClient = MockClient((request) async {
        return http.Response('{"error": "Internal server error"}', 500);
      });
      
      summarizer = SummarizerImpl(baseUrl: baseUrl, httpClient: mockClient);
      
      expect(
        () => summarizer.summarizeFigure('/path/to/pdf', '5'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('도표 요약 처리 실패'),
          ),
        ),
      );
    });
  });
}
