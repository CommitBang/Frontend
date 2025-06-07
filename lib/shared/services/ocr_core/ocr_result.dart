// lib/shared/services/ocr_core/ocr_result.dart

/// OCR 분석 결과 모델 (frontend‐friendly JSON)
class OCRResult {
  final String title;
  final List<Chapter> chapters;
  final List<PageDetail> pages;
  final Metadata metadata;

  OCRResult({
    required this.title,
    required this.chapters,
    required this.pages,
    required this.metadata,
  });

  factory OCRResult.fromJson(Map<String, dynamic> json) {
    return OCRResult(
      title: json['title'] as String,
      chapters:
          (json['chapters'] as List)
              .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
              .toList(),
      pages:
          (json['pages'] as List)
              .map((e) => PageDetail.fromJson(e as Map<String, dynamic>))
              .toList(),
      metadata: Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );
  }
}

/// 챕터 정보
class Chapter {
  final int chapterNumber;
  final String? title;
  final int startPage;
  final int endPage;
  final List<String> sections;
  final int? figureCount;

  Chapter({
    required this.chapterNumber,
    this.title,
    required this.startPage,
    required this.endPage,
    required this.sections,
    this.figureCount,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterNumber: (json['chapter'] as num).toInt(),
      title: json['title'] as String?,
      startPage: (json['start_page'] as num).toInt(),
      endPage: (json['end_page'] as num).toInt(),
      sections: (json['sections'] as List).map((e) => e as String).toList(),
      figureCount:
          json['figure_count'] != null
              ? (json['figure_count'] as num).toInt()
              : null,
    );
  }
}

/// 페이지 상세 정보
class PageDetail {
  final int pageIndex;
  final String chapter;
  final String? section;
  final List<LayoutItem> layouts;

  PageDetail({
    required this.pageIndex,
    required this.chapter,
    this.section,
    required this.layouts,
  });

  factory PageDetail.fromJson(Map<String, dynamic> json) {
    return PageDetail(
      pageIndex: (json['page_index'] as num).toInt(),
      chapter: json['chapter'] as String,
      section: json['section'] as String?,
      layouts:
          (json['layouts'] as List)
              .map((e) => LayoutItem.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

/// 레이아웃 추상 클래스
abstract class LayoutItem {
  final String type;
  final List<double> boundingBox;

  LayoutItem({required this.type, required this.boundingBox});

  factory LayoutItem.fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case 'text':
        return TextLayout.fromJson(json);
      case 'figure':
        return FigureLayoutItem.fromJson(json);
      case 'figure_reference':
        return FigureReferenceLayout.fromJson(json);
      default:
        throw UnimplementedError('Unknown layout type: ${json['type']}');
    }
  }
}

/// 텍스트 레이아웃
class TextLayout extends LayoutItem {
  final String text;
  final double confidence;

  TextLayout({
    required super.boundingBox,
    required this.text,
    required this.confidence,
  }) : super(type: 'text');

  factory TextLayout.fromJson(Map<String, dynamic> json) {
    return TextLayout(
      boundingBox:
          (json['bounding_box'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
      text: json['text'] as String,
      confidence: (json['confidence'] as num).toDouble(),
    );
  }
}

/// 피겨 레이아웃
class FigureLayoutItem extends LayoutItem {
  final String figureId;
  final String caption;
  final int figureNumber;

  FigureLayoutItem({
    required super.boundingBox,
    required this.figureId,
    required this.caption,
    required this.figureNumber,
  }) : super(type: 'figure');

  factory FigureLayoutItem.fromJson(Map<String, dynamic> json) {
    return FigureLayoutItem(
      boundingBox:
          (json['bounding_box'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
      figureId: json['figure_id'] as String,
      caption: json['figure_caption'] as String,
      figureNumber: (json['figure_number'] as num).toInt(),
    );
  }
}

/// 피겨 참조 레이아웃
class FigureReferenceLayout extends LayoutItem {
  final String referencedFigureId;
  final String referenceText;
  final double confidence;

  FigureReferenceLayout({
    required super.boundingBox,
    required this.referencedFigureId,
    required this.referenceText,
    required this.confidence,
  }) : super(type: 'figure_reference');

  factory FigureReferenceLayout.fromJson(Map<String, dynamic> json) {
    return FigureReferenceLayout(
      boundingBox:
          (json['bounding_box'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
      referencedFigureId: json['referenced_figure_id'] as String,
      referenceText: json['reference_text'] as String,
      confidence: (json['confidence'] as num).toDouble(),
    );
  }
}

/// 메타데이터
class Metadata {
  final int totalPages;
  final double processingTime;
  final int totalFigures;

  Metadata({
    required this.totalPages,
    required this.processingTime,
    required this.totalFigures,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      totalPages: (json['total_pages'] as num).toInt(),
      processingTime: (json['processing_time'] as num).toDouble(),
      totalFigures: (json['total_figures'] as num).toInt(),
    );
  }
}
