import 'package:snapfig/shared/services/ocr_core/models/bounding_box.dart';
import 'package:snapfig/shared/services/ocr_core/models/interactive_element.dart';

class UncaptionedImage extends InteractiveElement {
  final int xref;
  final String pdfFilename;
  final String elementType;

  const UncaptionedImage({
    required super.pageNum,
    required super.referenceBbox,
    required this.xref,
    required this.pdfFilename,
    this.elementType = 'uncaptioned_image',
  });

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['xref'] = xref;
    json['pdf_filename'] = pdfFilename;
    json['element_type'] = elementType;
    return json;
  }

  factory UncaptionedImage.fromJson(Map<String, dynamic> json) {
    try {
      return UncaptionedImage(
        pageNum: json['page_num'] as int,
        referenceBbox: BoundingBox.fromJson(
          json['reference_bbox'] as Map<String, dynamic>,
        ),
        xref: json['xref'] as int,
        pdfFilename: json['pdf_filename'] as String,
        elementType: json['element_type'] as String? ?? 'uncaptioned_image',
      );
    } catch (e) {
      throw AssertionError('UncaptionedImage.fromJson error: $e, $json');
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UncaptionedImage &&
        super == other &&
        other.xref == xref &&
        other.pdfFilename == pdfFilename &&
        other.elementType == elementType;
  }

  @override
  int get hashCode =>
      Object.hash(super.hashCode, xref, pdfFilename, elementType);
}
