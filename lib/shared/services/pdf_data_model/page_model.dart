import 'package:isar/isar.dart';
import 'layout_model.dart';
import 'pdf_model.dart';

part 'page_model.g.dart';

@collection
class PageModel {
  Id id = Isar.autoIncrement;

  // 소속 PDF
  IsarLink<PDFModel> pdf = IsarLink<PDFModel>();

  // 페이지 인덱스
  int pageIndex;

  // 페이지 높이
  int height;

  // 페이지 너비
  int width;

  PageModel({
    required this.pageIndex,
    required this.height,
    required this.width,
  });

  List<LayoutModel> getLayouts() => [];
}
