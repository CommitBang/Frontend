import 'package:flutter/material.dart';
import 'package:snapfig/shared/services/pdf_core/pdf_core.dart';

void showRenameDialog(
  BuildContext context,
  BasePdf pdfData,
  PDFProvider pdfProvider,
) async {
  final textEditController = TextEditingController(text: pdfData.name);
  await showDialog(
    context: context,
    builder: (dialogContext) {
      final theme = Theme.of(dialogContext);
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('문서 이름 변경'),
        titleTextStyle: theme.textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        content: TextField(
          controller: textEditController,
          decoration: const InputDecoration(hintText: '문서 이름을 입력하세요'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              if (textEditController.text.isNotEmpty) {
                pdfProvider.updatePDF(
                  id: pdfData.id,
                  name: textEditController.text,
                );
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('확인'),
          ),
        ],
      );
    },
  );
}
