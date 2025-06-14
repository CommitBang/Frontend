import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snapfig/shared/services/pdf_core/models/models.dart';
import 'package:snapfig/core/theme/theme.dart';
import 'package:intl/intl.dart';

class PdfListItem extends StatelessWidget {
  final BasePdf pdfData;
  final VoidCallback? onTap;
  final bool isEditing;
  final bool isSelected;
  final Function()? onEdit;
  final ValueChanged<bool?>? onSelected;

  const PdfListItem({
    super.key,
    required this.pdfData,
    this.isEditing = false,
    this.isSelected = false,
    this.onTap,
    this.onSelected,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      enabled: pdfData.status == PDFStatus.completed,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      trailing:
          isEditing
              ? null
              : IconButton(
                onPressed: onEdit,
                color: theme.colorScheme.onSurfaceVariant,
                icon: const Icon(Icons.edit_outlined),
              ),
      leading: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child:
            isEditing
                ? Checkbox(
                  value: isSelected,
                  onChanged:
                      pdfData.status != PDFStatus.processing
                          ? onSelected
                          : null,
                  activeColor: theme.colorScheme.primary,
                  checkColor: theme.colorScheme.onPrimary,
                )
                : _Thumbnail(thumbnail: pdfData.thumbnail),
      ),
      title: Text(
        pdfData.name,
        style: appTextTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child:
            pdfData.status == PDFStatus.completed
                ? _PDFMetadata(
                  totalPages: pdfData.totalPages,
                  updatedAt: pdfData.updatedAt,
                  key: const ValueKey('metadata'),
                )
                : _OCRProgressBar(
                  status: pdfData.status,
                  key: const ValueKey('progress'),
                ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final List<int>? thumbnail;
  final double _size = 56;

  const _Thumbnail({this.thumbnail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child:
              thumbnail != null
                  ? Image.memory(
                    Uint8List.fromList(thumbnail!),
                    key: const ValueKey('thumbnail'),
                    fit: BoxFit.cover,
                    width: _size,
                    height: _size,
                    errorBuilder:
                        (context, error, stackTrace) => Icon(
                          Icons.picture_as_pdf,
                          size: 32,
                          color: theme.colorScheme.onSurface,
                        ),
                  )
                  : Icon(
                    Icons.picture_as_pdf,
                    key: const ValueKey('pdf_icon'),
                    size: 32,
                    color: theme.colorScheme.onSurface,
                  ),
        ),
      ),
    );
  }
}

class _PDFMetadata extends StatelessWidget {
  final int totalPages;
  final DateTime updatedAt;

  const _PDFMetadata({
    super.key,
    required this.totalPages,
    required this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy.MM.dd');
    return Text(
      '$totalPages페이지 / ${dateFormat.format(updatedAt)}',
      style: appTextTheme.bodySmall?.copyWith(
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _OCRProgressBar extends StatelessWidget {
  final PDFStatus status;

  const _OCRProgressBar({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = switch (status) {
      PDFStatus.pending => 0.3,
      PDFStatus.completed => 1.0,
      PDFStatus.processing => 0.5,
      PDFStatus.failed => 0.0,
    };
    final progressText = switch (status) {
      PDFStatus.pending => 'PDF 정보 추출 중',
      PDFStatus.completed => 'PDF 정보 추출 완료',
      PDFStatus.processing => 'PDF 정보 추출 중',
      PDFStatus.failed => 'PDF 정보 추출 실패',
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          progressText,
          style: appTextTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: progress),
          duration: const Duration(milliseconds: 400),
          builder: (context, value, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 5,
                backgroundColor: theme.colorScheme.secondaryContainer,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
