import 'package:snapfig/shared/services/pdf_core/models/models.dart';

// 더미 PDF 데이터용 클래스 (BasePdf 구현)
class DummyPdf implements BasePdf {
  final int index;
  DummyPdf({required this.index});

  @override
  String get name => '샘플 PDF $index';
  @override
  String get path => '/sample/path/$index.pdf';
  @override
  DateTime get createdAt => DateTime.now().subtract(Duration(days: index * 2));
  @override
  DateTime get updatedAt => DateTime.now().subtract(Duration(days: index));
  @override
  int get totalPages => 10 + index;
  @override
  int get currentPage => 1;
  @override
  PDFStatus get status =>
      index == 2 ? PDFStatus.processing : PDFStatus.completed;
  @override
  List<BasePage> getPages() => [];
}
