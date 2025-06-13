import 'package:flutter/material.dart';
import 'package:snapfig/features/pdf_viewer/models/pdf_data_viewmodel.dart';
import 'package:snapfig/shared/services/pdf_core/models/models.dart';

class FigureOverlayWidget extends StatefulWidget {
  final BaseLayout reference;
  final PDFDataViewModel viewModel;
  final VoidCallback onClose;
  final void Function(BaseLayout figure)? navigateToFigure;
  final void Function(BaseLayout figure)? onAskAI;

  const FigureOverlayWidget({
    super.key,
    required this.reference,
    required this.viewModel,
    required this.onClose,
    this.navigateToFigure,
    this.onAskAI,
  });

  @override
  State<FigureOverlayWidget> createState() => _FigureOverlayWidgetState();
}

class _FigureOverlayWidgetState extends State<FigureOverlayWidget> {
  final TransformationController _transformationController = TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Find the actual figure that this reference points to
    final targetFigure = widget.viewModel.findFigureByReference(widget.reference);
    if (targetFigure == null) return _buildNotFoundContent(context);

    return FutureBuilder(
      future: widget.viewModel.getFigureImage(targetFigure),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingContent(context);
        } else if (snapshot.hasData && snapshot.data != null) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Figure image with zoom controls
                Container(
                  padding: const EdgeInsets.all(8),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final image = snapshot.data!;
                      final imageAspectRatio = image.width / image.height;

                      // Dynamic sizing based on screen size and content
                      final screenSize = MediaQuery.of(context).size;
                      final availableWidth = constraints.maxWidth - 16;
                      
                      // Adaptive height based on screen size
                      final maxHeightRatio = screenSize.height > 800 ? 0.5 : 0.4;
                      final availableHeight = screenSize.height * maxHeightRatio;

                      double displayWidth;
                      double displayHeight;

                      final widthBasedHeight = availableWidth / imageAspectRatio;
                      final heightBasedWidth = availableHeight * imageAspectRatio;

                      if (widthBasedHeight <= availableHeight) {
                        displayWidth = availableWidth;
                        displayHeight = widthBasedHeight;
                      } else {
                        displayWidth = heightBasedWidth;
                        displayHeight = availableHeight;
                      }

                      // Dynamic minimum constraints based on screen size
                      final minWidth = screenSize.width * 0.2;
                      final minHeight = screenSize.height * 0.1;
                      
                      displayWidth = displayWidth.clamp(minWidth, availableWidth);
                      displayHeight = displayHeight.clamp(minHeight, availableHeight);

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
                          child: InteractiveViewer(
                            transformationController: _transformationController,
                            minScale: 0.5,
                            maxScale: 4.0,
                            constrained: true,
                            child: RawImage(
                              image: image,
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                            ),
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
                            widget.navigateToFigure?.call(targetFigure);
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
                        const SizedBox(height: 8),
                        FilledButton.icon(
                          onPressed: () {
                            widget.onAskAI?.call(targetFigure);
                          },
                          icon: const Icon(Icons.smart_toy, size: 18),
                          label: const Text('Ask AI'),
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
            onPressed: widget.onClose,
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
