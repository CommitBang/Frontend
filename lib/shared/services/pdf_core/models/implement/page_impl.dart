import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:snapfig/shared/services/pdf_core/models/implement/layout_impl.dart';
import 'package:snapfig/shared/services/pdf_core/models/implement/pdf_impl.dart';
import 'package:snapfig/shared/services/pdf_core/models/interface/base_page.dart';

part 'page_impl.g.dart';

@collection
@Name('pdf_page')
class PageModel extends BasePage {
  // ====== DB 필드 ======
  @override
  Id id = Isar.autoIncrement;

  @override
  @Name('page_index')
  final int pageIndex;

  @Name('full_text')
  @override
  final String fullText;

  final double _width;
  final double _height;

  // ====== 관계 ======
  @Backlink(to: 'page')
  final layouts = IsarLinks<LayoutModel>();

  IsarLink<PDFModel> pdf = IsarLink<PDFModel>();

  // ====== 생성자 ======
  PageModel({
    required this.pageIndex,
    required this.fullText,
    required double width,
    required double height,
  }) : _width = width,
       _height = height;

  PageModel.create({
    required this.pageIndex,
    required this.fullText,
    required Size size,
  }) : _width = size.width,
       _height = size.height;

  // ====== 게터 ======
  @override
  @ignore
  Size get size => Size(_width, _height);

  @Name('width')
  double get width => _width;
  @Name('height')
  double get height => _height;

  @override
  Future<List<LayoutModel>> getLayouts() async => [];
}
