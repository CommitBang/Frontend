// base_layout.dart

import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

enum LayoutType { formula, text, number, header, algorithm, figure, figureReference }

// PDF 레이아웃 데이터 모델 인터페이스
abstract class BaseLayout {
  // 고유 식별자
  Id get id;

  // 레이아웃 타입
  LayoutType get type;

  // 레이아웃 내용
  String get content;

  // 텍스트 레이아웃일 경우 값을 가집니다.
  String? get text;

  // 수식 레이아웃일 경우 값을 가집니다. 라텍스 형식으로 저장합니다.
  String? get latex;

  // 레이아웃 위치
  @ignore
  Rect get rect;
  
  // Figure 관련 속성들
  // figure 타입일 경우 figure ID를 가집니다.
  String? get figureId;
  
  // figure 타입일 경우 figure 번호를 가집니다.
  int? get figureNumber;
  
  // figure 타입일 경우 캡션을 가집니다.
  String? get caption;
  
  // figureReference 타입일 경우 참조하는 figure ID를 가집니다.
  String? get referencedFigureId;
  
  // figureReference 타입일 경우 참조 텍스트를 가집니다.
  String? get referenceText;
}
