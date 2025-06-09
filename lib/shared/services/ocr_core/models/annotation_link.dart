import 'package:snapfig/shared/services/ocr_core/models/bounding_box.dart';
import 'package:snapfig/shared/services/ocr_core/models/interactive_element.dart';

class AnnotationLink extends InteractiveElement {
  final String targetText;
  final String someOptionalField;

  const AnnotationLink({
    required super.pageNum,
    required super.referenceBbox,
    required this.targetText,
    this.someOptionalField = 'default_value',
  });

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['target_text'] = targetText;
    json['some_optional_field'] = someOptionalField;
    return json;
  }

  factory AnnotationLink.fromJson(Map<String, dynamic> json) {
    return AnnotationLink(
      pageNum: json['page_num'] as int,
      referenceBbox: BoundingBox.fromJson(
        json['reference_bbox'] as Map<String, dynamic>,
      ),
      targetText: json['target_text'] as String,
      someOptionalField:
          json['some_optional_field'] as String? ?? 'default_value',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnnotationLink &&
        super == other &&
        other.targetText == targetText &&
        other.someOptionalField == someOptionalField;
  }

  @override
  int get hashCode =>
      Object.hash(super.hashCode, targetText, someOptionalField);
}
