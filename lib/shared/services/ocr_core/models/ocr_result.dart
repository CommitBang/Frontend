import 'package:flutter/widgets.dart';
import 'package:snapfig/shared/services/ocr_core/models/annotation_link.dart';
import 'package:snapfig/shared/services/ocr_core/models/bounding_box.dart';
import 'package:snapfig/shared/services/ocr_core/models/figure_link.dart';
import 'package:snapfig/shared/services/ocr_core/models/interactive_element.dart';
import 'package:snapfig/shared/services/ocr_core/models/uncaptioned_image.dart';

class TextBlock {
  final String text;
  final Rect bbox;

  const TextBlock({required this.text, required this.bbox});

  factory TextBlock.fromJson(Map<String, dynamic> json) {
    final bbox = json['bbox'] as List;
    return TextBlock(
      text: json['text'] as String,
      bbox: Rect.fromLTWH(
        bbox[0].toDouble(),
        bbox[1].toDouble(),
        bbox[2].toDouble(),
        bbox[3].toDouble(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'bbox': [bbox.left, bbox.top, bbox.right, bbox.bottom],
    };
  }
}

class PageData {
  final int pageNum;
  final List<TextBlock> blocks;
  final Size size;

  const PageData({
    required this.pageNum,
    required this.blocks,
    required this.size,
  });

  factory PageData.fromJson(Map<String, dynamic> json) {
    final size = json['page_size'] as List;
    return PageData(
      pageNum: (json['page_number'] as num).toInt(),
      size: Size(size[0].toDouble(), size[1].toDouble()),
      blocks:
          (json['blocks'] as List<dynamic>)
              .map((block) {
                final blockMap = block as Map<String, dynamic>;
                if (blockMap['type'] == 'text') {
                  return TextBlock.fromJson(blockMap);
                }
                return null;
              })
              .whereType<TextBlock>()
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
              case 'annotation_link':
                return AnnotationLink.fromJson(elementMap);
            }
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
