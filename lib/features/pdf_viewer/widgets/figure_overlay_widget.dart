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
                  padding: const EdgeInsets.all(8),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final image = snapshot.data!;
                      final imageAspectRatio = image.width / image.height;

                      // Calculate optimal display size completely based on image aspect ratio
                      final availableWidth =
                          constraints.maxWidth - 16; // Account for padding
                      final availableHeight =
                          MediaQuery.of(context).size.height *
                          0.4; // Max 40% of screen height

                      double displayWidth;
                      double displayHeight;

                      // Calculate size that fits within available space while maintaining aspect ratio
                      final widthBasedHeight =
                          availableWidth / imageAspectRatio;
                      final heightBasedWidth =
                          availableHeight * imageAspectRatio;

                      if (widthBasedHeight <= availableHeight) {
                        // Width is the limiting factor
                        displayWidth = availableWidth;
                        displayHeight = widthBasedHeight;
                      } else {
                        // Height is the limiting factor
                        displayWidth = heightBasedWidth;
                        displayHeight = availableHeight;
                      }

                      // Only apply minimal constraints to prevent unusable sizes
                      displayWidth = displayWidth.clamp(100.0, availableWidth);
                      displayHeight = displayHeight.clamp(
                        40.0,
                        availableHeight,
                      );

                      return Container(
                        width: displayWidth,
                        height: displayHeight,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: RawImage(
                            image: image,
                            fit:
                                BoxFit
                                    .contain, // Show entire image without cropping
                            alignment: Alignment.center,
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FilledButton.tonalIcon(
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
                        FilledButton.icon(
                          onPressed: () {
                            navigateToFigure?.call(targetFigure);
                          },
                          icon: const Icon(Icons.search, size: 18),
                          label: const Text('Ask to AI'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
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
