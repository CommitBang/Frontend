import 'package:flutter/material.dart';
import 'package:snapfig/shared/services/pdf_core/models/models.dart';

class FigureHighlightWidget extends StatefulWidget {
  final BaseLayout layout;
  final VoidCallback? onFigureReferenceTap;
  final VoidCallback? onAskAI;

  const FigureHighlightWidget({
    super.key,
    required this.layout,
    this.onFigureReferenceTap,
    this.onAskAI,
  });

  @override
  State<FigureHighlightWidget> createState() => _FigureHighlightWidgetState();
}

class _FigureHighlightWidgetState extends State<FigureHighlightWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _borderAnimation;
  late Animation<double> _buttonAnimation;

  bool _isActivated = false;
  OverlayEntry? _askAIOverlay;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _borderAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );
  }

  @override
  void dispose() {
    _dismissAskAIOverlay();
    _animationController.dispose();
    super.dispose();
  }

  bool get isFigure => widget.layout.type == LayoutType.figure;
  bool get isFigureReference =>
      widget.layout.type == LayoutType.figureReference;

  void _onTap() {
    if (isFigure) {
      // For figures, show Circle to Search effect
      print(
        'Figure tapped! isFigure: $isFigure, onAskAI: ${widget.onAskAI != null}',
      );
      if (!_isActivated) {
        setState(() {
          _isActivated = true;
        });
        _animationController.forward();
        
        // Show Ask AI overlay after border animation starts
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted && _isActivated) {
            _showAskAIOverlay();
          }
        });

        // Auto dismiss after 5 seconds (increased for testing)
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted && _isActivated) {
            _dismiss();
          }
        });
      }
    } else if (isFigureReference) {
      // For figure references, call the traditional handler
      print('Figure reference tapped!');
      widget.onFigureReferenceTap?.call();
    }
  }

  void _dismiss() {
    if (_isActivated) {
      _dismissAskAIOverlay();
      _animationController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _isActivated = false;
          });
        }
      });
    }
  }

  void _showAskAIOverlay() {
    if (_askAIOverlay != null) return;

    // Get the widget's position on screen
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    
    // Calculate button position (top-right of the figure)
    final buttonLeft = position.dx + size.width - 80;
    final buttonTop = position.dy - 10;

    final overlay = Overlay.of(context);
    
    _askAIOverlay = OverlayEntry(
      builder: (context) => Positioned(
        left: buttonLeft,
        top: buttonTop,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedBuilder(
            animation: _buttonAnimation,
            builder: (context, child) {
              final animationValue = _buttonAnimation.value.clamp(0.0, 1.0);
              final scale = animationValue;
              final opacity = animationValue;

              return Transform.scale(
                scale: scale.clamp(0.0, 3.0),
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      print('AI button tapped!');
                      if (widget.onAskAI != null) {
                        widget.onAskAI!.call();
                      } else {
                        print('onAskAI is null!');
                      }
                      _dismiss();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.smart_toy,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Ask AI',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    overlay.insert(_askAIOverlay!);
  }

  void _dismissAskAIOverlay() {
    _askAIOverlay?.remove();
    _askAIOverlay = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    print(
      'Building FigureHighlightWidget: isFigure=$isFigure, isActivated=$_isActivated, onAskAI=${widget.onAskAI != null}',
    );

    return GestureDetector(
      onTap: _onTap,
      child: Stack(
        children: [
          // Base container
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              // Figure references are visible, figures are transparent
              color:
                  isFigureReference
                      ? theme.colorScheme.primary.withValues(alpha: 0.2)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),

          // Animated border overlay for figures only
          if (isFigure && _isActivated)
            AnimatedBuilder(
              animation: _borderAnimation,
              builder: (context, child) {
                final animationValue = _borderAnimation.value.clamp(0.0, 1.0);
                final opacity = animationValue;
                final scale = 0.95 + (animationValue * 0.05);

                return Transform.scale(
                  scale: scale.clamp(0.0, 2.0),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(
                          alpha: (opacity * 0.8).clamp(0.0, 1.0),
                        ),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                      color: theme.colorScheme.primary.withValues(
                        alpha: (opacity * 0.05).clamp(0.0, 1.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: (opacity * 0.2).clamp(0.0, 1.0),
                          ),
                          blurRadius: 8.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Corner highlights (Gemini-style)
                        Positioned(
                          top: -1,
                          left: -1,
                          child: _buildCornerHighlight(
                            theme,
                            opacity,
                            true,
                            true,
                          ),
                        ),
                        Positioned(
                          top: -1,
                          right: -1,
                          child: _buildCornerHighlight(
                            theme,
                            opacity,
                            true,
                            false,
                          ),
                        ),
                        Positioned(
                          bottom: -1,
                          left: -1,
                          child: _buildCornerHighlight(
                            theme,
                            opacity,
                            false,
                            true,
                          ),
                        ),
                        Positioned(
                          bottom: -1,
                          right: -1,
                          child: _buildCornerHighlight(
                            theme,
                            opacity,
                            false,
                            false,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),


          // Tap to dismiss overlay for figures
          if (isFigure && _isActivated)
            Positioned.fill(
              child: GestureDetector(
                onTap: _dismiss,
                child: Container(color: Colors.transparent),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCornerHighlight(
    ThemeData theme,
    double opacity,
    bool isTop,
    bool isLeft,
  ) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        border: Border(
          top:
              isTop
                  ? BorderSide(
                    color: theme.colorScheme.primary.withValues(
                      alpha: opacity.clamp(0.0, 1.0),
                    ),
                    width: 3.0,
                  )
                  : BorderSide.none,
          bottom:
              !isTop
                  ? BorderSide(
                    color: theme.colorScheme.primary.withValues(
                      alpha: opacity.clamp(0.0, 1.0),
                    ),
                    width: 3.0,
                  )
                  : BorderSide.none,
          left:
              isLeft
                  ? BorderSide(
                    color: theme.colorScheme.primary.withValues(
                      alpha: opacity.clamp(0.0, 1.0),
                    ),
                    width: 3.0,
                  )
                  : BorderSide.none,
          right:
              !isLeft
                  ? BorderSide(
                    color: theme.colorScheme.primary.withValues(
                      alpha: opacity.clamp(0.0, 1.0),
                    ),
                    width: 3.0,
                  )
                  : BorderSide.none,
        ),
      ),
    );
  }
}
