import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              _PdfThumbnail(thumbnail: pdfData.thumbnail),
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
  final List<int>? thumbnail;
  const _PdfThumbnail({this.thumbnail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      child: Center(
        child:
            thumbnail != null
                ? Image.memory(
                  Uint8List.fromList(thumbnail!),
                  fit: BoxFit.fill,
                  errorBuilder:
                      (context, error, stackTrace) => Icon(
                        Icons.picture_as_pdf,
                        size: 48,
                        color: theme.colorScheme.onSurface,
                      ),
                )
                : Icon(
                  Icons.picture_as_pdf,
                  size: 48,
                  color: theme.colorScheme.onSurface,
                ),
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
            child: _PdfCardActions(
              onEdit: onEdit,
              onOpen: onOpen,
              status: pdfData.status,
            ),
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
  final PDFStatus status;

  const _PdfCardActions({
    required this.onEdit,
    required this.onOpen,
    required this.status,
  });

  void _showCantOpenSnackBar(BuildContext context) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '처리가 완료되지 않은 문서는 열 수 없습니다.',
          style: appTextTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onErrorContainer,
          ),
        ),
        backgroundColor: theme.colorScheme.errorContainer,
        closeIconColor: theme.colorScheme.onErrorContainer,
      ),
    );
  }

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
              disabledBackgroundColor: theme.colorScheme.surfaceDim,
              disabledForegroundColor: theme.colorScheme.onSecondaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            onPressed:
                status == PDFStatus.completed
                    ? onOpen
                    : () => _showCantOpenSnackBar(context),
            child: const Text('열기'),
          ),
        ],
      ),
    );
  }
}
