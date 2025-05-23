import 'package:isar/isar.dart';
import 'page_model.dart';

part 'layout_model.g.dart';

enum LayoutType { formula, text, number, header, algorithm }

@collection
class LayoutModel {
  Id id = Isar.autoIncrement;

  IsarLink<PageModel> page = IsarLink<PageModel>();

  // 레이아웃 타입
  @enumerated
  LayoutType type;

  // 레이아웃 내용
  String content;

  // 텍스트 레이아웃일 경우 값을 가집니다.
  String? text;

  // 수식 레이아웃일 경우 값을 가집니다. 라텍스 형식으로 저장합니다.
  String? latex;

  // 레이아웃 위치
  double left;
  double top;
  double width;
  double height;

  LayoutModel({
    required this.type,
    required this.content,
    this.text,
    this.latex,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
}
