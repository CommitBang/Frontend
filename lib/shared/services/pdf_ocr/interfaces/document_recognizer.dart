import 'package:flutter/services.dart';

import './document_model.dart';

/// 문서 인식 오류
class DocumentRecognizationError extends Error {
  final String message;

  DocumentRecognizationError(this.message);
}

/// 문서 인식 결과
class DocumentRecognizationResult {
  /// 문서 인식 결과
  final DocumentData document;

  /// 인식 성공 여부
  final bool isSuccess;

  /// 인식 오류 정보
  final DocumentRecognizationError? error;

  DocumentRecognizationResult({
    required this.document,
    required this.isSuccess,
    this.error,
  });
}

/// 문서 인식 인터페이스
///
/// 문서 1페이지에 대해 문서 인식 결과를 반환합니다.
abstract class DocumentRecognizationProcess {
  /// 문서 이미지 비트맵
  final Uint8List imgBitmap;

  /// 문서 이미지 크기
  final Size imgSize;

  DocumentRecognizationProcess({
    required this.imgBitmap,
    required this.imgSize,
  });

  /// 문서 인식
  Future<DocumentRecognizationResult> recognize();

  /// 처리 중단
  void cancel();
}
