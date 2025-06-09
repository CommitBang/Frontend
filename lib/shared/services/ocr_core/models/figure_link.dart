import 'package:snapfig/shared/services/ocr_core/models/bounding_box.dart';
import 'package:snapfig/shared/services/ocr_core/models/interactive_element.dart';

class FigureLink extends InteractiveElement {
  final int targetXref;
  final String pdfFilename;
  final String elementType;

  const FigureLink({
    required super.pageNum,
    required super.referenceBbox,
    required this.targetXref,
    required this.pdfFilename,
    this.elementType = 'figure',
  });

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['target_xref'] = targetXref;
    json['pdf_filename'] = pdfFilename;
    json['element_type'] = elementType;
    return json;
  }

  factory FigureLink.fromJson(Map<String, dynamic> json) {
    return FigureLink(
      pageNum: json['page_num'] as int,
      referenceBbox: BoundingBox.fromJson(
        json['reference_bbox'] as Map<String, dynamic>,
      ),
      targetXref: json['target_xref'] as int,
      pdfFilename: json['pdf_filename'] as String,
      elementType: json['element_type'] as String? ?? 'figure',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FigureLink &&
        super == other &&
        other.targetXref == targetXref &&
        other.pdfFilename == pdfFilename &&
        other.elementType == elementType;
  }

  @override
  int get hashCode =>
      Object.hash(super.hashCode, targetXref, pdfFilename, elementType);
}
