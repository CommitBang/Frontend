import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snapfig/features/home/screens/dummy_pdf.dart';
import 'package:snapfig/features/home/widgets/home_components.dart';
import 'package:snapfig/shared/services/pdf_core/pdf_core.dart';

class RecentWidget extends StatefulWidget {
  const RecentWidget({super.key});

  @override
  State<RecentWidget> createState() => _RecentWidgetState();
}

class _RecentWidgetState extends State<RecentWidget> {
  // 샘플 PDF 데이터
  List<BasePdf> get samplePdfs => List.generate(13, (i) => DummyPdf(index: i));
  static const int _maxRecentPdfs = 5;

  @override
  Widget build(BuildContext context) {
    final pdfProvider = InheritedPDFProviderWidget.of(context).provider;
    return Scaffold(
      body: FutureBuilder(
        future: pdfProvider.queryPDFs(limit: 13),
        builder:
            (context, snapshot) =>
                snapshot.hasData
                    ? _buildRecentWidget(context, snapshot.data!)
                    : const SizedBox.shrink(),
      ),
      floatingActionButton: const AddDocumentButton(),
    );
  }

  Widget _buildRecentWidget(BuildContext context, List<BasePdf> pdfs) {
    final theme = Theme.of(context);
    final recentPdfs = pdfs.take(_maxRecentPdfs).toList();
    final otherPdfs = pdfs.skip(_maxRecentPdfs).toList();
    final isEmpty = pdfs.isEmpty;
    return Stack(
      children: [
        if (isEmpty)
          const Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [EmptyFilesIcon()],
            ),
          ),
        if (recentPdfs.isNotEmpty)
          CustomScrollView(
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
              if (recentPdfs.isNotEmpty)
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
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        children:
                            recentPdfs
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
                      pdfData: otherPdfs[itemIndex],
                      onTap: () {},
                      isEditing: false,
                    );
                  }
                  return Divider(height: 1, color: theme.colorScheme.outline);
                }, childCount: max(otherPdfs.length * 2 - 1, 0)),
              ),
            ],
          ),
      ],
    );
  }
}
