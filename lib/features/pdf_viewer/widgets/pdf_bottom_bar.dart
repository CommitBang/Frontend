import 'package:flutter/material.dart';

const double kStatusBarHeight = 48;

class PDFBottomBar extends StatelessWidget {
  final int zoomPercent;
  final int currentPage;
  final int totalPages;
  final bool sidebarVisible;
  final VoidCallback onSidebarToggle;
  const PDFBottomBar({
    super.key,
    required this.zoomPercent,
    required this.currentPage,
    required this.totalPages,
    required this.sidebarVisible,
    required this.onSidebarToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: kStatusBarHeight,
        color: Theme.of(context).colorScheme.surfaceContainer,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$zoomPercent%',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '$currentPage / $totalPages',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: sidebarVisible ? 'Hide sidebar' : 'Show sidebar',
              onPressed: onSidebarToggle,
            ),
          ],
        ),
      ),
    );
  }
}
