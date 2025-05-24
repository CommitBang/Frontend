import 'package:flutter/material.dart';
import 'package:snapfig/shared/services/pdf_core/models/models.dart';
import 'package:snapfig/core/theme/theme.dart';
import 'package:intl/intl.dart';

class PdfCard extends StatelessWidget {
  final BasePdf pdfData;
  final VoidCallback onEdit;
  final VoidCallback onOpen;

  static const double minInfoWidth = 120;
  static const double minActionsWidth = 230;
  static const double fadeRange = 60; // 투명도 변화 구간(px)

  const PdfCard({
    super.key,
    required this.pdfData,
    required this.onEdit,
    required this.onOpen,
  });

  double _calculateInfoOpacity(double width) {
    if (width <= minInfoWidth) return 0.0;
    if (width < minInfoWidth + fadeRange) {
      return (width - minInfoWidth) / fadeRange;
    }
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final infoOpacity = _calculateInfoOpacity(constraints.maxWidth);
        final showActions = constraints.maxWidth > minActionsWidth;

        return Container(
          color: theme.colorScheme.surface,
          child: Stack(
            children: [
              const Positioned.fill(child: _PdfThumbnail()),
              AnimatedOpacity(
                opacity: infoOpacity,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Padding(
                  padding: const EdgeInsets.only(top: 130),
                  child: _PDFMetadata(
                    pdfData: pdfData,
                    onEdit: onEdit,
                    onOpen: onOpen,
                    showActions: showActions,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PdfThumbnail extends StatelessWidget {
  const _PdfThumbnail();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: const Center(
        child: Icon(Icons.picture_as_pdf, size: 48, color: Color(0xFF898989)),
      ),
    );
  }
}

class _PDFMetadata extends StatelessWidget {
  final BasePdf pdfData;
  final VoidCallback onEdit;
  final VoidCallback onOpen;
  final bool showActions;

  const _PDFMetadata({
    required this.pdfData,
    required this.onEdit,
    required this.onOpen,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PdfTextContent(
            name: pdfData.name,
            totalPages: pdfData.totalPages,
            updatedAt: pdfData.updatedAt,
          ),
          const Spacer(),
          AnimatedOpacity(
            opacity: showActions ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: _PdfCardActions(onEdit: onEdit, onOpen: onOpen),
          ),
        ],
      ),
    );
  }
}

class _PdfTextContent extends StatelessWidget {
  final String name;
  final int totalPages;
  final DateTime updatedAt;

  const _PdfTextContent({
    required this.name,
    required this.totalPages,
    required this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy.MM.dd');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: appTextTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '$totalPages페이지 / ${dateFormat.format(updatedAt)}',
            style: appTextTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}

class _PdfCardActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onOpen;

  const _PdfCardActions({required this.onEdit, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              side: BorderSide(color: theme.colorScheme.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            onPressed: onEdit,
            child: const Text('수정'),
          ),
          const SizedBox(width: 8),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            onPressed: onOpen,
            child: const Text('열기'),
          ),
        ],
      ),
    );
  }
}
