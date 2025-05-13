import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:logging/logging.dart';
import 'package:snapfig/shared/services/pdf_ocr/implements/pdf_ocr_impl.dart';
import 'package:snapfig/shared/services/pdf_ocr/interfaces/pdf_ocr.dart';
import 'package:snapfig/shared/services/pdf_ocr/interfaces/text_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// PDFOCRProcess 인스턴스를 생성하는 팩토리 메서드
PDFOCRProcess _createPDFOCRProcess(String pdfPath, LanguageType languageType) {
  // PDFOCRProcess 구현체 넣기
  return PDFOCRProcessImpl(pdfPath: pdfPath, languageType: languageType);
}

// asset을 임시 디렉토리로 복사하는 함수
Future<String> _copyAssetToTempFile(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  final tempDir = Directory.systemTemp;
  final tempFile = File('${tempDir.path}/sample.pdf');
  await tempFile.writeAsBytes(byteData.buffer.asUint8List());
  return tempFile.path;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // 로깅
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.message}');
  });

  // 테스트용 자원 설정
  const assetPdfPath = 'integration_test/assets/sample.pdf';
  late String testPdfPath;
  late PDFOCRProcess pdfOcrProcess;

  setUp(() async {
    testPdfPath = await _copyAssetToTempFile(assetPdfPath);
    pdfOcrProcess = _createPDFOCRProcess(testPdfPath, LanguageType.english);
  });

  group('PDFOCRProcess 통합 테스트', () {
    test('초기화 시 상태가 올바르게 설정되어야 함', () {
      expect(pdfOcrProcess.pdfPath, testPdfPath);
      expect(pdfOcrProcess.languageType, LanguageType.english);
    });

    test('process() 호출 시 중복 실행 예외가 발생해야 함', () async {
      pdfOcrProcess.process();
      expect(
        () => pdfOcrProcess.process(),
        throwsA(
          isA<PDFOCRException>().having(
            (e) => e.type,
            'exception type',
            PDFOCRExceptionType.duplicateProcess,
          ),
        ),
      );
      pdfOcrProcess.cancel();
    });

    test(
      'process()가 올바른 PDFOCRResult를 반환해야 함',
      () async {
        final result = await pdfOcrProcess.process();
        expect(result, isA<PDFOCRResult>());
        expect(result.pdfPath, testPdfPath);
        expect(result.pages, isNotEmpty);
        expect(result.pages.first.columns, isNotEmpty);
      },
      timeout: const Timeout(Duration(minutes: 1)),
    );

    test('페이지 처리 실패 시 적절한 에러 처리가 되어야 함', () async {
      final failProcess = _createPDFOCRProcess(
        'test/assets/not_exist.pdf',
        LanguageType.english,
      );
      expect(
        () async => await failProcess.process(),
        throwsA(isA<PDFOCRException>()),
      );
    });

    test('텍스트 인식 결과가 올바른 형식으로 변환되어야 함', () async {
      final result = await pdfOcrProcess.process();
      expect(result.pages, isNotEmpty);
      final page = result.pages.first;

      // 텍스트 추출 내용 확인
      final expectedColumns = [
        '''Chapter 1''',
        '''Introduction''',
        '''
Programming languages are notations for describing computations to people
and to machines. The world as we know it depends on programming languages,
because all the software running on all the computers was written in some
programming language. But, before a program can be run, it first must be
translated into a form in which it can be executed by a computer.
''',
        '''
The software systems that do this translation are called compilers.
''',
        '''
This book is about how to design and implement compilers. We shall dis-
cover that a few basic ideas can be used to construct translators for a wide
variety of languages and machines. Besides compilers, the principles and tech-
niques for compiler design are applicable to so many other domains that they
are likely to be reused many times in the career of a computer scientist. The
study of compiler writing touches upon programming languages, machine ar-
chitecture, language theory, algorithms, and software engineering.
''',
        '''
In this preliminary chapter, we introduce the different forms of language
translators, give a high level overview of the structure of a typical compiler,
and discuss the trends in programming languages and machine architecture
that are shaping compilers. We include some observations on the relationship
between compiler design and computer-science theory and an outline of the
applications of compiler technology that go beyond compilation. We end with
a brief outline of key programming-language concepts that will be needed for
our study of compilers.
''',
        '''1.1 Language Processors''',
        '''
Simply stated, a compiler is a program that can read a program in one lan-
guage — the source language — and translate it into an equivalent program in
another language — the target language; see Fig. 1.1. An important role of the
compiler is to report any errors in the source program that it detects during
the translation process.
''',
      ];
      expect(page.columns.length, expectedColumns.length);
      for (int i = 0; i < page.columns.length; i++) {
        expect(page.columns[i].text, expectedColumns[i]);
      }
    }, timeout: const Timeout(Duration(minutes: 1)));
  });
}
