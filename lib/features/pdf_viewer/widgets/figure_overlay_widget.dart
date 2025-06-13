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
    final theme = Theme.of(context);
    // Find the actual figure that this reference points to
    final targetFigure = viewModel.findFigureByReference(reference);
    if (targetFigure == null) return _buildNotFoundContent(context);

    return FutureBuilder(
      future: viewModel.getFigureImage(targetFigure),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingContent(context);
        } else if (snapshot.hasData && snapshot.data != null) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Figure image
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 180,
                    minHeight: 100,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        width: double.infinity,
                        height: constraints.maxHeight,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: RawImage(
                            image: snapshot.data!,
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Action button
                Container(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        navigateToFigure?.call(targetFigure);
                      },
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: const Text('Go to Figure'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
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

  Widget _buildLoadingContent(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading figure...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFoundContent(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 48,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Figure not found',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The referenced figure could not be located in the document.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 16),
            label: const Text('Close'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
