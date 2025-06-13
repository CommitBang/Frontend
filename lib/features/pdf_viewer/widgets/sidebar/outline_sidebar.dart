import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class OutlineSidebar extends StatelessWidget {
  final List<PdfOutlineNode> outlines;
  final Function(PdfOutlineNode) onOutlineSelected;

  const OutlineSidebar({
    super.key,
    required this.outlines,
    required this.onOutlineSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: outlines.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: _buildThumbnail(outlines[index], context: context),
          title: Text(outlines[index].title),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => onOutlineSelected(outlines[index]),
        );
      },
    );
  }

  Widget _buildThumbnail(
    PdfOutlineNode outline, {
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        Icons.picture_as_pdf,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
