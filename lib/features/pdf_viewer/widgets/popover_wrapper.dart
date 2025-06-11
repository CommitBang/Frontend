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
    const popoverWidth = 280.0;
    const popoverHeight = 200.0;
    const arrowSize = 8.0;
    
    // Determine if popover should appear above or below the target
    final showAbove = targetPosition.dy > screenSize.height / 2;
    
    // Calculate horizontal position (center on target, but keep within screen bounds)
    double left = targetPosition.dx - popoverWidth / 2;
    if (left < 16) left = 16;
    if (left + popoverWidth > screenSize.width - 16) {
      left = screenSize.width - popoverWidth - 16;
    }
    
    // Calculate vertical position
    final top = showAbove 
        ? targetPosition.dy - popoverHeight - arrowSize - 8
        : targetPosition.dy + arrowSize + 8;
    
    // Calculate arrow position relative to popover
    final arrowLeft = (targetPosition.dx - left).clamp(arrowSize, popoverWidth - arrowSize);
    
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
                    height: popoverHeight,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: child,
                    ),
                  ),
                ),
              ),
              // Arrow
              Positioned(
                left: left + arrowLeft - arrowSize,
                top: showAbove ? top + popoverHeight : top - arrowSize,
                child: CustomPaint(
                  size: Size(arrowSize * 2, arrowSize),
                  painter: _ArrowPainter(
                    color: theme.colorScheme.surface,
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
  final bool pointsUp;

  _ArrowPainter({required this.color, required this.pointsUp});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

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

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}