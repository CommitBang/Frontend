import 'package:flutter_test/flutter_test.dart';
import 'package:snapfig/shared/services/ocr_core/ocr_core.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as path_lib;
import 'dart:io';

/// assetPath: 예) 'test/unit/assets/test.pdf'
/// 반환: 내부 저장소에 복사된 파일의 경로
Future<String> copyAssetToLocal(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  final tempDir = await Directory.systemTemp.createTemp('test_pdf_');
  final fileName = path_lib.basename(assetPath);
  final file = File(path_lib.join(tempDir.path, fileName));
  await file.writeAsBytes(byteData.buffer.asUint8List());
  return file.path;
}

void main() {
  late OCRProvider provider;

  setUp(() {
    provider = OCRProviderImpl(
      baseUrl: 'https://b08b-165-194-27-212.ngrok-free.app',
    );
  });

  test('process()는 OCRResult를 반환해야 한다', () async {
    final pdfPath = await copyAssetToLocal('integration_test/assets/test.pdf');
    final result = await provider.process(pdfPath);
    expect(result, isA<OCRResult>());
    expect(result.paragraphData.pages, isNotEmpty);
    expect(result.interactiveElements, isNotEmpty);
  }, timeout: const Timeout(Duration(minutes: 15)));

  test('process()에 잘못된 경로를 넣어도 예외가 발생하지 않는다', () async {
    final result = await provider.process('invalid/path.pdf');
    expect(result, isA<OCRResult>());
  });
}
