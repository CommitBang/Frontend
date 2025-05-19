import 'package:flutter/services.dart';
import 'package:ultralytics_yolo/yolo.dart';
import './layout_model.dart';

class LayoutDetectionError extends Error {
  final String message;

  LayoutDetectionError(this.message);
}

/// 레이아웃 인식 결과
class LayoutDetectionResult {
  /// 인식된 레이아웃 목록
  final List<LayoutData> layouts;

  /// 인식 성공 여부
  final bool isSuccess;

  /// 인식 오류 정보
  final LayoutDetectionError? error;

  LayoutDetectionResult({
    required this.layouts,
    required this.isSuccess,
    this.error,
  });
}

/// 레이아웃 인식 인터페이스
abstract class LayoutDetectionProcess {
  static YOLO? yolo;

  /// 이미지 비트맵
  final Uint8List imgBitmap;

  /// 이미지 크기
  final Size imgSize;

  LayoutDetectionProcess({required this.imgBitmap, required this.imgSize});

  /// 레이아웃 인식
  Future<LayoutDetectionResult> detect();
}
