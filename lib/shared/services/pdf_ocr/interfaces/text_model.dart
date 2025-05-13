import 'package:flutter/material.dart' show Rect;

/// 지원되는 언어 타입
///
/// 현재 지원되는 언어는 영어와 한국어입니다.
enum LanguageType { english, korean, uknown }

extension LanguageTypeExtension on LanguageType {
  static LanguageType fromString(String code) {
    return switch (code) {
      'en' => LanguageType.english,
      'ko' => LanguageType.korean,
      _ => LanguageType.uknown,
    };
  }
}

/// 텍스트 열 데이터
///
/// 텍스트 열은 한 문단을 의미하며, 여러 줄로 구성됩니다.
class TextColumnData {
  /// 텍스트 열의 텍스트 내용
  final String text;

  /// 텍스트 열의 위치와 크기
  final Rect rect;

  /// 텍스트 열의 줄 데이터
  final List<LineData> lines;

  TextColumnData({required this.text, required this.rect, required this.lines});
}

/// 텍스트 줄 데이터
///
/// 텍스트 줄은 한 문단의 한 줄을 의미합니다.
class LineData {
  /// 텍스트 줄의 텍스트 내용
  final String text;

  /// 텍스트 줄의 위치와 크기
  final Rect rect;

  /// 텍스트 줄의 신뢰도
  final double confidence;

  /// 텍스트 줄의 단어 데이터
  final List<WordData> words;

  LineData({
    required this.text,
    required this.rect,
    required this.confidence,
    required this.words,
  });
}

/// 텍스트 단어 데이터
///
/// 텍스트 단어는 한 문단의 한 줄의 한 단어를 의미합니다.
class WordData {
  /// 텍스트 단어의 텍스트 내용
  final String text;

  /// 텍스트 단어의 위치와 크기
  final Rect rect;

  /// 텍스트 단어의 언어
  final List<LanguageType> languages;

  /// 텍스트 단어의 신뢰도
  final double confidence;

  WordData({
    required this.text,
    required this.rect,
    required this.confidence,
    required this.languages,
  });
}
