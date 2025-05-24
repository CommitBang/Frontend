import 'package:flutter/material.dart';
import 'package:snapfig/shared/services/pdf_core/models/models.dart';
import 'package:snapfig/core/theme/theme.dart';
import 'package:intl/intl.dart';

class PdfListItem extends StatelessWidget {
  final BasePdf pdfData;
  final VoidCallback? onTap;
  final bool isEditing;
  final bool isSelected;
  final Function(bool?)? onSelected;

  const PdfListItem({
    super.key,
    required this.pdfData,
    this.isEditing = false,
    this.isSelected = false,
    this.onTap,
    this.onSelected,
  });

  Widget _buildThumbnail(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(Icons.picture_as_pdf, size: 32, color: Color(0xFF898989)),
      ),
    );
  }

  Widget _buildMetadata(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy.MM.dd');
    return Text(
      '${pdfData.totalPages}페이지 / ${dateFormat.format(pdfData.updatedAt)}',
      style: appTextTheme.bodySmall?.copyWith(
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildOCRProgressBar(BuildContext context) {
    final theme = Theme.of(context);
    final progress = switch (pdfData.status) {
      PDFStatus.pending => 0.3,
      PDFStatus.completed => 1.0,
      PDFStatus.processing => 0.5,
      PDFStatus.failed => 0.0,
    };
    final progressText = switch (pdfData.status) {
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
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            backgroundColor: theme.colorScheme.secondaryContainer,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox(BuildContext context) {
    final theme = Theme.of(context);
    return Checkbox(
      value: isSelected,
      onChanged:
          (value) =>
              pdfData.status != PDFStatus.processing
                  ? onSelected?.call(value)
                  : null,
      activeColor: theme.colorScheme.primary,
      checkColor: theme.colorScheme.onPrimary,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      enabled: pdfData.status == PDFStatus.completed,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              child: child,
            ),
          );
        },
        child: isEditing ? _buildCheckbox(context) : _buildThumbnail(context),
      ),
      title: Text(
        pdfData.name,
        style: appTextTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle:
          pdfData.status == PDFStatus.completed
              ? _buildMetadata(context)
              : _buildOCRProgressBar(context),
    );
  }
}
