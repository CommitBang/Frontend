import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snapfig/shared/services/pdf_core/models/models.dart';
import 'pdf_card.dart';
import 'pdf_list_item.dart';

class RecentWidget extends StatefulWidget {
  const RecentWidget({super.key});

  @override
  State<RecentWidget> createState() => _RecentWidgetState();
}

class _RecentWidgetState extends State<RecentWidget> {
  // 샘플 PDF 데이터
  List<BasePdf> get samplePdfs => List.generate(5, (i) => DummyPdf(index: i));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pdfs = samplePdfs;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: const Text('최근 문서'),
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 1,
            centerTitle: true,
            expandedHeight: 100,
            toolbarHeight: 56,
            collapsedHeight: 70,
            titleTextStyle: theme.textTheme.headlineSmall,
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CarouselView(
                  itemExtent: 300,
                  enableSplash: false,
                  padding: const EdgeInsets.fromLTRB(4, 11, 4, 11),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: theme.colorScheme.outline),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  children:
                      pdfs
                          .map(
                            (pdf) => PdfCard(
                              pdfData: pdf,
                              onEdit: () {},
                              onOpen: () {},
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, idx) {
              final itemIndex = idx ~/ 2;
              if (idx.isEven) {
                return PdfListItem(
                  pdfData: pdfs[itemIndex],
                  onTap: () {},
                  isEditing: false,
                );
              }
              return Divider(height: 1, color: theme.colorScheme.outline);
            }, childCount: max(pdfs.length * 2 - 1, 0)),
          ),
        ],
      ),
      floatingActionButton: OutlinedButton.icon(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: theme.colorScheme.secondaryContainer,
        ),
        label: const Text('새 문서 추가'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

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
