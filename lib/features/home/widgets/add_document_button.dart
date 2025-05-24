import 'package:flutter/material.dart';

class AddDocumentButton extends StatelessWidget {
  const AddDocumentButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: theme.colorScheme.secondaryContainer,
      ),
      label: const Text('새 문서 추가'),
      icon: const Icon(Icons.add),
    );
  }
}
