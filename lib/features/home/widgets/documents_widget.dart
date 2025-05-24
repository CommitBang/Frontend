import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snapfig/features/home/widgets/add_document_button.dart';
import 'package:snapfig/shared/services/pdf_core/models/models.dart';
import 'package:snapfig/features/home/widgets/dummy_pdf.dart';
import 'package:snapfig/features/home/widgets/pdf_list_item.dart';

class DocumentsWidget extends StatefulWidget {
  const DocumentsWidget({super.key});

  @override
  State<DocumentsWidget> createState() => _DocumentsWidgetState();
}

class _DocumentsWidgetState extends State<DocumentsWidget> {
  final List<BasePdf> pdfs = List.generate(10, (i) => DummyPdf(index: i));
  final List<BasePdf> _selectedPdfs = [];
  bool _isEditing = false;

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _onSelectPDF(BasePdf pdf, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedPdfs.add(pdf);
      } else {
        _selectedPdfs.remove(pdf);
      }
    });
  }

  void _onCancel() {
    setState(() {
      _isEditing = false;
      _selectedPdfs.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 1,
            centerTitle: true,
            expandedHeight: 100,
            toolbarHeight: 56,
            collapsedHeight: 70,
            title: const Text('문서'),
            titleTextStyle: theme.textTheme.headlineSmall,
            actions: [
              AnimatedOpacity(
                opacity: _isEditing ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: IconButton(
                  onPressed: _isEditing ? null : _toggleEditing,
                  icon: const Icon(Icons.edit),
                ),
              ),
            ],
          ),
          SliverList.builder(
            itemBuilder: (context, index) {
              final itemIndex = index ~/ 2;
              if (index.isEven) {
                return PdfListItem(
                  pdfData: pdfs[itemIndex],
                  onTap: () {},
                  onSelected:
                      (isItemSelected) => _onSelectPDF(
                        pdfs[itemIndex],
                        isItemSelected ?? false,
                      ),
                  isSelected: _selectedPdfs.contains(pdfs[itemIndex]),
                  isEditing: _isEditing,
                );
              }
              return Divider(height: 1, color: theme.colorScheme.outline);
            },
            itemCount: max(pdfs.length * 2 - 1, 0),
          ),
        ],
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child:
            _isEditing ? null : const AddDocumentButton(key: ValueKey('fab')),
      ),
      bottomNavigationBar: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child:
            _isEditing
                ? _DocumentsBottomBar(
                  key: const ValueKey('bottom-bar'),
                  selectedCount: _selectedPdfs.length,
                  onDelete: () {},
                  onCancel: _onCancel,
                )
                : const SizedBox.shrink(key: ValueKey('empty-bar')),
      ),
    );
  }
}

class _DocumentsBottomBar extends StatelessWidget {
  final Function onDelete;
  final Function onCancel;
  final int selectedCount;

  const _DocumentsBottomBar({
    super.key,
    required this.onDelete,
    required this.onCancel,
    required this.selectedCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 0,
      color: theme.colorScheme.surface,
      child: SafeArea(
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => onCancel(),
                  child: const Text('취소'),
                ),
                FilledButton.icon(
                  onPressed: () => selectedCount > 0 ? onDelete() : null,
                  style: FilledButton.styleFrom(
                    foregroundColor: theme.colorScheme.onErrorContainer,
                    backgroundColor: theme.colorScheme.errorContainer,
                  ),
                  icon: const Icon(Icons.delete),
                  label: const Text('삭제하기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
