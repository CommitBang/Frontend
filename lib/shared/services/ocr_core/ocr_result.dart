// lib/shared/services/ocr_core/ocr_result.dart

/// OCR 분석 결과 모델 (프론트엔드용)
class OCRResult {
  /// 문서 제목 (null 이거나 누락되면 빈 문자열)
  final String title;

  /// 챕터 리스트
  final List<Chapter> chapters;

  /// 페이지별 상세
  final List<PageDetail> pages;

  /// 본문 중 Figure 객체
  final List<Figure> figures;

  /// 전체 메타데이터
  final Metadata metadata;

  OCRResult({
    required this.title,
    required this.chapters,
    required this.pages,
    required this.figures,
    required this.metadata,
  });

  factory OCRResult.fromJson(Map<String, dynamic> json) {
    // 1) title
    final rawTitle = json['title'];
    final title = rawTitle is String ? rawTitle : '';

    // 2) chapters
    final chaptersJson = json['chapters'] as List<dynamic>? ?? <dynamic>[];
    final chapters =
        chaptersJson
            .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
            .toList();

    // 3) pages
    final pagesJson = json['pages'] as List<dynamic>? ?? <dynamic>[];
    final pages =
        pagesJson
            .map((e) => PageDetail.fromJson(e as Map<String, dynamic>))
            .toList();

    // 4) figures
    final figsJson = json['figures'] as List<dynamic>? ?? <dynamic>[];
    final figures =
        figsJson
            .map((e) => Figure.fromJson(e as Map<String, dynamic>))
            .toList();

    // 5) metadata
    final metaJson = json['metadata'] as Map<String, dynamic>? ?? {};
    final metadata = Metadata.fromJson(metaJson);

    return OCRResult(
      title: title,
      chapters: chapters,
      pages: pages,
      figures: figures,
      metadata: metadata,
    );
  }
}

/// 챕터 정보
class Chapter {
  final int chapterNumber;
  final String title;
  final int startPage;
  final int endPage;
  final List<String> sections;

  Chapter({
    required this.chapterNumber,
    required this.title,
    required this.startPage,
    required this.endPage,
    required this.sections,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterNumber: (json['chapter_number'] as num).toInt(),
      title: (json['title'] as String?) ?? '',
      startPage: (json['start_page'] as num).toInt(),
      endPage: (json['end_page'] as num).toInt(),
      sections:
          (json['sections'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          <String>[],
    );
  }
}

/// 페이지 상세 정보
class PageDetail {
  final int pageIndex;
  final String? chapter;
  final String? section;
  final List<LayoutItem> layouts;
  final String fullText;

  PageDetail({
    required this.pageIndex,
    this.chapter,
    this.section,
    required this.layouts,
    required this.fullText,
  });

  factory PageDetail.fromJson(Map<String, dynamic> json) {
    // layouts
    final layoutsJson = json['layouts'] as List<dynamic>? ?? <dynamic>[];
    final layouts =
        layoutsJson
            .map((e) => LayoutItem.fromJson(e as Map<String, dynamic>))
            .toList();

    return PageDetail(
      pageIndex: (json['page_index'] as num).toInt(),
      chapter: json['chapter'] as String?,
      section: json['section'] as String?,
      layouts: layouts,
      fullText: (json['full_text'] as String?) ?? '',
    );
  }
}

/// Figure 정보 (예시에선 빈 배열이지만 구조를 맞춰 파싱)
class Figure {
  final String id;
  final List<double> boundingBox;
  final String? caption;
  final int? pageIndex;

  Figure({
    required this.id,
    required this.boundingBox,
    this.caption,
    this.pageIndex,
  });

  factory Figure.fromJson(Map<String, dynamic> json) {
    return Figure(
      id: json['figure_id'] as String? ?? '',
      boundingBox:
          (json['bounding_box'] as List<dynamic>? ?? <dynamic>[])
              .map((e) => (e as num).toDouble())
              .toList(),
      caption: json['caption'] as String?,
      pageIndex:
          json['page_index'] != null
              ? (json['page_index'] as num).toInt()
              : null,
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
      text: json['text'] as String? ?? '',
      confidence: ((json['confidence'] ?? 0) as num).toDouble(),
    );
  }
}

/// Figure 레이아웃 (본문 내 그림 박스)
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
      figureId: (json['figure_id'] ?? '') as String,
      caption: (json['caption'] ?? '') as String,
      figureNumber: ((json['figure_number'] ?? 0) as num).toInt(),
    );
  }
}

/// Figure 참조 레이아웃 (본문 내 그림 언급)
class FigureReferenceLayout extends LayoutItem {
  final String referencedFigureId;
  final String referenceText;
  final int figureNumber;
  final double confidence;

  FigureReferenceLayout({
    required super.boundingBox,
    required this.referencedFigureId,
    required this.referenceText,
    required this.figureNumber,
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
      figureNumber: (json['figure_number'] as num).toInt(),
      confidence: ((json['confidence'] ?? 0) as num).toDouble(),
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
