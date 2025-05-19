import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:logging/logging.dart';
import 'package:snapfig/shared/services/pdf_ocr/implements/layout_detection_impl.dart';
import 'package:snapfig/shared/services/pdf_ocr/interfaces/layout_detection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'dart:ui';

// 샘플 이미지를 임시 디렉토리로 복사하는 함수
Future<String> _copyAssetToTempFile(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  final tempDir = Directory.systemTemp;
  final tempFile = File('${tempDir.path}/sample_layout.png');
  await tempFile.writeAsBytes(byteData.buffer.asUint8List());
  return tempFile.path;
}

// 샘플 이미지를 로드하여 Uint8List로 반환
Future<Uint8List> _loadSampleImageBytes(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  return byteData.buffer.asUint8List();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // 로깅
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.message}');
  });

  // 테스트용 자원 설정
  const assetImagePath =
      'integration_test/assets/sample_layout.png'; // 실제 샘플 이미지는 별도 추가 필요
  late Uint8List testImgBytes;
  late LayoutDetectionProcess layoutProcess;

  setUp(() async {
    final tempPath = await _copyAssetToTempFile(assetImagePath);
    testImgBytes = await _loadSampleImageBytes(tempPath);
    layoutProcess = LayoutDetectionProcessImpl(
      imgBitmap: testImgBytes,
      imgSize: const Size(1764, 2264),
    );
  });

  group('LayoutDetectionProcess 통합 테스트', () {
    test('초기화 시 파라미터가 올바르게 설정되어야 함', () {
      expect(layoutProcess.imgBitmap, testImgBytes);
    });

    test('detect() 호출 시 LayoutDetectionResult가 반환되어야 함', () async {
      final result = await layoutProcess.detect();
      expect(result, isA<LayoutDetectionResult>());
      expect(result.layouts, isNotEmpty);
      expect(result.isSuccess, isTrue);
    });
  });
}
