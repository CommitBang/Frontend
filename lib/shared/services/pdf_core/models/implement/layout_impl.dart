import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:snapfig/shared/services/pdf_core/models/implement/page_impl.dart';
import 'package:snapfig/shared/services/pdf_core/models/interface/base_layout.dart';

part 'layout_impl.g.dart';

@collection
@Name('pdf_layout')
class LayoutModel extends BaseLayout {
  // ====== DB 필드 ======
  @override
  Id id = Isar.autoIncrement;

  @override
  @enumerated
  final LayoutType type;
  @override
  final String content;
  @override
  final String? text;
  @override
  final String? latex;

  final double _top;
  final double _left;
  final double _width;
  final double _height;

  // ====== 관계 ======
  IsarLink<PageModel> page = IsarLink<PageModel>();

  // ====== 생성자 ======
  LayoutModel({
    required this.type,
    required this.content,
    this.text,
    this.latex,
    required double top,
    required double left,
    required double width,
    required double height,
  }) : _top = top,
       _left = left,
       _width = width,
       _height = height;

  LayoutModel.create({
    required this.type,
    required this.content,
    required this.text,
    required this.latex,
    required Rect box,
  }) : _top = box.top,
       _left = box.left,
       _width = box.width,
       _height = box.height;

  // ====== 게터 ======
  @override
  @ignore
  Rect get rect => Rect.fromLTWH(_left, _top, _width, _height);

  @Name('top')
  double get top => _top;
  @Name('left')
  double get left => _left;
  @Name('width')
  double get width => _width;
  @Name('height')
  double get height => _height;
}
