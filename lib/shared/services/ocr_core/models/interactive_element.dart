import 'package:snapfig/shared/services/ocr_core/models/bounding_box.dart';

abstract class InteractiveElement {
  final int pageNum;
  final BoundingBox referenceBbox;

  const InteractiveElement({
    required this.pageNum,
    required this.referenceBbox,
  });

  Map<String, dynamic> toJson() {
    return {
      'page_num': pageNum,
      'reference_bbox': referenceBbox.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InteractiveElement &&
        other.pageNum == pageNum &&
        other.referenceBbox == referenceBbox;
  }

  @override
  int get hashCode => Object.hash(pageNum, referenceBbox);
}