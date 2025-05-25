import 'dart:typed_data';

import 'package:isar/isar.dart';
import 'package:snapfig/shared/services/pdf_core/models/implement/page_impl.dart';
import 'package:snapfig/shared/services/pdf_core/models/interface/base_pdf.dart';

part 'pdf_impl.g.dart';

@collection
@Name('pdf')
class PDFModel extends BasePdf {
  // ====== DB 필드 ======
  @override
  Id id = Isar.autoIncrement;

  String _name;

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

  PDFStatus _status;

  // ====== 관계 ======
  @Backlink(to: 'pdf')
  final pages = IsarLinks<PageModel>();

  // ====== 생성자 ======
  PDFModel({
    required String name,
    required this.path,
    required this.createdAt,
    required this.totalPages,
    required int currentPage,
    required PDFStatus status,
  }) : _currentPage = currentPage,
       _name = name,
       _status = status;

  PDFModel.create({
    required String name,
    required this.path,
    required this.createdAt,
    required this.totalPages,
    required PDFStatus status,
  }) : _name = name,
       _status = status;

  // ====== 게터 ======
  @Name('name')
  @override
  String get name => _name;

  @Name('pdf_status')
  @enumerated
  @override
  PDFStatus get status => _status;

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

  void update({String? name, DateTime? updatedAt, PDFStatus? status}) {
    _name = name ?? _name;
    _updatedAt = updatedAt ?? _updatedAt;
    _status = status ?? _status;
  }
}
