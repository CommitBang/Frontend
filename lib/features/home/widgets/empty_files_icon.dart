import 'package:flutter/material.dart';

class EmptyFilesIcon extends StatelessWidget {
  const EmptyFilesIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconPath = switch (theme.brightness) {
      Brightness.light => 'assets/icons/nofiles_light.png',
      Brightness.dark => 'assets/icons/nofiles_dark.png',
    };
    return Column(
      children: [
        Image.asset(iconPath, width: 165, height: 165, fit: BoxFit.contain),
        const SizedBox(height: 3),
        Text(
          '문서가 없습니다.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
