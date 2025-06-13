import 'package:flutter/material.dart';

class PopoverWrapper extends StatelessWidget {
  final Offset targetPosition;
  final Widget child;
  final VoidCallback? onDismiss;

  const PopoverWrapper({
    super.key,
    required this.targetPosition,
    required this.child,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    // Calculate popover position
    const popoverWidth = 300.0;
    const popoverMaxHeight = 320.0;
    const arrowSize = 10.0;
    const margin = 20.0;

    // Determine if popover should appear above or below the target
    final spaceAbove = targetPosition.dy - margin;
    final spaceBelow = screenSize.height - targetPosition.dy - margin;
    final showAbove = spaceAbove > spaceBelow && spaceAbove > popoverMaxHeight;

    // Calculate horizontal position (center on target, but keep within screen bounds)
    double left = targetPosition.dx - popoverWidth / 2;
    if (left < margin) left = margin;
    if (left + popoverWidth > screenSize.width - margin) {
      left = screenSize.width - popoverWidth - margin;
    }

    // Calculate vertical position with better spacing
    final top =
        showAbove
            ? targetPosition.dy - popoverMaxHeight - arrowSize - 8
            : targetPosition.dy + arrowSize + 8;

    // Calculate arrow position relative to popover (clamped to ensure it's visible)
    final arrowLeft = (targetPosition.dx - left).clamp(
      arrowSize * 2,
      popoverWidth - arrowSize * 2,
    );

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onDismiss,
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              // Popover container
              Positioned(
                left: left,
                top: top,
                child: GestureDetector(
                  onTap: () {}, // Prevent tap from bubbling up
                  child: Container(
                    width: popoverWidth,
                    constraints: const BoxConstraints(
                      maxHeight: popoverMaxHeight,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                        width: 0.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: child,
                    ),
                  ),
                ),
              ),
              // Arrow
              Positioned(
                left: left + arrowLeft - arrowSize,
                top: showAbove ? top + popoverMaxHeight : top - arrowSize,
                child: CustomPaint(
                  size: Size(arrowSize * 2, arrowSize),
                  painter: _ArrowPainter(
                    color: theme.colorScheme.surface,
                    borderColor: theme.colorScheme.outline.withValues(
                      alpha: 0.2,
                    ),
                    pointsUp: !showAbove,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final bool pointsUp;

  _ArrowPainter({
    required this.color,
    required this.borderColor,
    required this.pointsUp,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final borderPaint =
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;

    final path = Path();

    if (pointsUp) {
      path.moveTo(size.width / 2, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width / 2, size.height);
    }
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
