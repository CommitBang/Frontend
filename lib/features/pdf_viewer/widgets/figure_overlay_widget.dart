import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:snapfig/features/pdf_viewer/models/pdf_data_viewmodel.dart';
import 'package:snapfig/shared/services/pdf_core/models/models.dart';

class FigureOverlayWidget extends StatelessWidget {
  final BaseLayout reference;
  final PDFDataViewModel viewModel;
  final VoidCallback onClose;
  final void Function(BaseLayout figure)? navigateToFigure;

  const FigureOverlayWidget({
    super.key,
    required this.reference,
    required this.viewModel,
    required this.onClose,
    this.navigateToFigure,
  });

  @override
  Widget build(BuildContext context) {
    // Find the actual figure that this reference points to
    final targetFigure = viewModel.findFigureByReference(reference);
    if (targetFigure == null) return _buildNotFoundContent(context);

    return FutureBuilder(
      future: viewModel.getFigureImage(targetFigure),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: RawImage(image: snapshot.data!),
                ),
                TextButton(
                  onPressed: () {
                    navigateToFigure?.call(targetFigure);
                  },
                  child: const Text('Go to figure'),
                ),
              ],
            ),
          );
        } else {
          return _buildNotFoundContent(context);
        }
      },
    );
  }

  Widget _buildNotFoundContent(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          Icons.image_not_supported,
          size: 48,
          color: theme.colorScheme.outline,
        ),
        const SizedBox(height: 16),
        Text('Figure not found', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          'The referenced figure could not be located in the document.',
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
