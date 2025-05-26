import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snapfig/features/home/widgets/home_components.dart';
import 'package:snapfig/shared/services/pdf_core/pdf_core.dart';

class DocumentsWidget extends StatefulWidget {
  const DocumentsWidget({super.key});

  @override
  State<DocumentsWidget> createState() => _DocumentsWidgetState();
}

class _DocumentsWidgetState extends State<DocumentsWidget> {
  final List<BasePdf> _selectedPdfs = [];
  bool _isEditing = false;
  late final PDFProvider _pdfProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pdfProvider = InheritedPDFProviderWidget.of(context).provider;
    _pdfProvider.addListener(_onPDFsChanged);
  }

  @override
  void dispose() {
    _pdfProvider.removeListener(_onPDFsChanged);
    super.dispose();
  }

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

  void _onDelete() {
    _pdfProvider.deletePDF(_selectedPdfs);
    _isEditing = false;
    setState(() {});
  }

  /// PDF 목록이 변경되었을 때 호출되는 함수
  void _onPDFsChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final pdfs = _pdfProvider.pdfs;
    final isEmpty = pdfs.isEmpty;
    return Scaffold(
      body: Stack(
        children: [
          if (isEmpty) const _EmptyFilesView(),
          if (!isEmpty)
            _DocumentsListView(
              pdfs: pdfs,
              selectedPdfs: _selectedPdfs,
              isEditing: _isEditing,
              onSelectPDF: _onSelectPDF,
              onToggleEditing: _toggleEditing,
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
                ? _DocumentsEditBottomBar(
                  key: const ValueKey('bottom-bar'),
                  selectedCount: _selectedPdfs.length,
                  onDelete: _onDelete,
                  onCancel: _onCancel,
                )
                : const SizedBox.shrink(key: ValueKey('empty-bar')),
      ),
    );
  }
}

class _EmptyFilesView extends StatelessWidget {
  const _EmptyFilesView();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [EmptyFilesIcon()],
      ),
    );
  }
}

class _DocumentsListView extends StatelessWidget {
  final List<BasePdf> pdfs;
  final List<BasePdf> selectedPdfs;
  final bool isEditing;
  final void Function(BasePdf, bool) onSelectPDF;
  final VoidCallback onToggleEditing;

  const _DocumentsListView({
    required this.pdfs,
    required this.selectedPdfs,
    required this.isEditing,
    required this.onSelectPDF,
    required this.onToggleEditing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomScrollView(
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
              opacity: isEditing ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: IconButton(
                onPressed: isEditing ? null : onToggleEditing,
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
                    (isItemSelected) =>
                        onSelectPDF(pdfs[itemIndex], isItemSelected ?? false),
                isSelected: selectedPdfs.contains(pdfs[itemIndex]),
                isEditing: isEditing,
              );
            }
            return Divider(height: 1, color: theme.colorScheme.outline);
          },
          itemCount: max(pdfs.length * 2 - 1, 0),
        ),
      ],
    );
  }
}

class _DocumentsEditBottomBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const _DocumentsEditBottomBar({
    super.key,
    required this.selectedCount,
    required this.onDelete,
    required this.onCancel,
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
                TextButton(onPressed: onCancel, child: const Text('취소')),
                FilledButton.icon(
                  onPressed: onDelete,
                  style: FilledButton.styleFrom(
                    foregroundColor: theme.colorScheme.onErrorContainer,
                    backgroundColor: theme.colorScheme.errorContainer,
                  ),
                  icon: const Icon(Icons.delete),
                  label: Text(
                    '삭제하기${selectedCount > 0 ? ' ($selectedCount)' : ''}',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
