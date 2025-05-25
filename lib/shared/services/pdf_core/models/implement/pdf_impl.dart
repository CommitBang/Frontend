import 'dart:typed_data';

import 'package:isar/isar.dart';
import 'package:snapfig/shared/services/pdf_core/models/implement/page_impl.dart';
import 'package:snapfig/shared/services/pdf_core/models/interface/base_pdf.dart';

part 'pdf_impl.g.dart';

@collection
@Name('pdf')
class PDFModel extends BasePdf {
  // ====== DB 필드 ======
  Id id = Isar.autoIncrement;

  @Name('name')
  @override
  final String name;

  @Name('path')
  @override
  final String path;

  @Name('created_at')
  @override
  final DateTime createdAt;

  DateTime? _updatedAt;

  @Name('total_pages')
  @override
  final int totalPages;

  int _currentPage = 0;

  @Name('pdf_status')
  @enumerated
  @override
  PDFStatus status;

  // ====== 관계 ======
  @Backlink(to: 'pdf')
  final pages = IsarLinks<PageModel>();

  // ====== 생성자 ======
  PDFModel({
    required this.name,
    required this.path,
    required this.createdAt,
    required this.totalPages,
    required int currentPage,
    required this.status,
  }) : _currentPage = currentPage;

  PDFModel.create({
    required this.name,
    required this.path,
    required this.createdAt,
    required this.totalPages,
    required this.status,
  });

  // ====== 게터 ======
  @Name('updated_at')
  @override
  DateTime get updatedAt => _updatedAt ?? createdAt;

  @Name('current_page')
  @override
  int get currentPage => _currentPage;

  @override
  Future<Uint8List?> getThumbnail() async => null;

  @override
  Future<List<PageModel>> getPages() async => [];
}
