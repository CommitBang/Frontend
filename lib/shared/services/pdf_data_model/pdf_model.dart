import 'package:isar/isar.dart';
import 'page_model.dart';

part 'pdf_model.g.dart';

enum PDFStatus { pending, processing, completed, failed }

@collection
class PDFModel {
  Id id = Isar.autoIncrement;

  // 파일 이름
  String name;

  // 파일 경로
  String path;

  // 생성 시간
  final DateTime createdAt;

  // 수정 시간
  DateTime updatedAt;

  // 총 페이지 수
  int totalPages;

  // 현재 페이지 번호
  int currentPage;

  @ignore
  PDFStatus _status = PDFStatus.pending;

  PDFModel({
    required this.name,
    required this.path,
    required this.createdAt,
    required this.updatedAt,
    required this.totalPages,
    required this.currentPage,
  });

  List<PageModel> getPages() => [];
}
