import 'package:flutter/material.dart';
import 'package:snapfig/features/home/screens/recent_widget.dart';
import 'package:snapfig/features/home/screens/documents_widget.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _selectedIndex = 0;

  final List<NavigationRailDestination> _destinations = [
    const NavigationRailDestination(
      icon: Icon(Icons.schedule),
      label: Text('최근'),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.description),
      label: Text('문서'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        _buildNavigationRail(context),
        VerticalDivider(width: 1, color: theme.colorScheme.outline),
        Expanded(child: _buildContentWidget(context)),
      ],
    );
  }

  Widget _buildNavigationRail(BuildContext context) {
    final theme = Theme.of(context);

    return NavigationRail(
      useIndicator: true,
      labelType: NavigationRailLabelType.all,
      destinations: _destinations,
      selectedIndex: _selectedIndex,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onDestinationSelected: (index) {
        setState(() => _selectedIndex = index);
      },
      minWidth: 80,
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/ai-settings');
                  },
                  icon: Icon(Icons.smart_toy, color: theme.colorScheme.primary),
                  tooltip: 'AI 설정',
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    foregroundColor: theme.colorScheme.onPrimaryContainer,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 컨텐츠 위젯
  Widget _buildContentWidget(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: _buildTransitionEffect, // 탭 전환 효과
        child:
            _selectedIndex == 0
                ? const RecentWidget()
                : const DocumentsWidget(),
      ),
    );
  }

  Widget _buildTransitionEffect(Widget child, Animation<double> animation) {
    // 들어오는 위젯
    final inAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    );
    // 나가는 위젯
    final outAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return Stack(
      children: [
        // 나가는 위젯(뒷페이지: 살짝 축소+페이드)
        if (animation.status == AnimationStatus.reverse)
          ScaleTransition(
            scale: Tween<double>(begin: 1.0, end: 0.96).animate(outAnimation),
            child: FadeTransition(
              opacity: Tween<double>(
                begin: 1.0,
                end: 0.0,
              ).animate(outAnimation),
              child: child,
            ),
          ),
        // 들어오는 위젯(슬라이드+페이드)
        if (animation.status != AnimationStatus.reverse)
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0), // 오른쪽에서 들어옴
              end: Offset.zero,
            ).animate(inAnimation),
            child: FadeTransition(opacity: inAnimation, child: child),
          ),
      ],
    );
  }
}
