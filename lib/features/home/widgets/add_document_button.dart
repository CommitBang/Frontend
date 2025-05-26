import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:snapfig/shared/services/pdf_core/pdf_core.dart';

class AddDocumentButton extends StatelessWidget {
  const AddDocumentButton({super.key});

  void _pickFile(BuildContext context) async {
    final pdfProvider = InheritedPDFProviderWidget.of(context).provider;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final path = file.path;
      if (path != null) {
        try {
          await pdfProvider.addPDF(path);
        } catch (e) {
          if (context.mounted) {
            _showErrorSnackbar(context, 'PDF를 불러오는데 실패했습니다.');
          }
        }
      } else {
        if (context.mounted) {
          _showErrorSnackbar(context, '파일 경로를 가져올 수 없습니다.');
        }
      }
    } else {
      if (context.mounted) {
        _showErrorSnackbar(context, '파일을 선택할 수 없습니다.');
      }
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onErrorContainer,
          ),
        ),
        duration: const Duration(seconds: 2),
        closeIconColor: theme.colorScheme.onErrorContainer,
        backgroundColor: theme.colorScheme.errorContainer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      onPressed: () => _pickFile(context),
      style: OutlinedButton.styleFrom(
        backgroundColor: theme.colorScheme.secondaryContainer,
      ),
      label: const Text('새 문서 추가'),
      icon: const Icon(Icons.add),
    );
  }
}
