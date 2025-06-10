import 'package:snapfig/shared/services/ocr_core/models/annotation_link.dart';
import 'package:snapfig/shared/services/ocr_core/models/figure_link.dart';
import 'package:snapfig/shared/services/ocr_core/models/interactive_element.dart';
import 'package:snapfig/shared/services/ocr_core/models/uncaptioned_image.dart';

class TextBlock {
  final String text;

  const TextBlock({required this.text});

  factory TextBlock.fromJson(Map<String, dynamic> json) {
    return TextBlock(text: json['text'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'text': text};
  }
}

class PageData {
  final int pageNum;
  final List<TextBlock> blocks;

  const PageData({required this.pageNum, required this.blocks});

  factory PageData.fromJson(Map<String, dynamic> json) {
    return PageData(
      pageNum: (json['page_num'] as num).toInt(),
      blocks:
          (json['blocks'] as List<dynamic>)
              .map((block) => TextBlock.fromJson(block as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page_num': pageNum,
      'blocks': blocks.map((block) => block.toJson()).toList(),
    };
  }
}

class ParagraphData {
  final List<PageData> pages;

  const ParagraphData({required this.pages});

  factory ParagraphData.fromJson(Map<String, dynamic> json) {
    return ParagraphData(
      pages:
          (json['pages'] as List<dynamic>)
              .map((page) => PageData.fromJson(page as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'pages': pages.map((page) => page.toJson()).toList()};
  }
}

class OCRResult {
  final List<InteractiveElement> interactiveElements;
  final ParagraphData paragraphData;

  const OCRResult({
    required this.interactiveElements,
    required this.paragraphData,
  });

  factory OCRResult.fromJson(Map<String, dynamic> json) {
    final elementsJson = json['interactive_elements'] as List<dynamic>;
    final elements =
        elementsJson.map((element) {
          final elementMap = element as Map<String, dynamic>;

          // Determine the type based on element_type field or presence of specific fields
          if (elementMap.containsKey('element_type')) {
            switch (elementMap['element_type']) {
              case 'figure':
                return FigureLink.fromJson(elementMap);
              case 'uncaptioned_image':
                return UncaptionedImage.fromJson(elementMap);
            }
          }

          // Check for type-specific fields
          if (elementMap.containsKey('target_text')) {
            return AnnotationLink.fromJson(elementMap);
          } else if (elementMap.containsKey('target_xref')) {
            return FigureLink.fromJson(elementMap);
          } else if (elementMap.containsKey('xref')) {
            return UncaptionedImage.fromJson(elementMap);
          }

          throw Exception('Unknown interactive element type: $elementMap');
        }).toList();

    return OCRResult(
      interactiveElements: elements,
      paragraphData: ParagraphData.fromJson(
        json['paragraph_data'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'interactive_elements':
          interactiveElements.map((element) => element.toJson()).toList(),
      'paragraph_data': paragraphData.toJson(),
    };
  }
}
