//main.dart

import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/pdf_viewer/screens/pdf_viewer_screen.dart';

void main() {
  runApp(const SmartPdfApp());
}

class SmartPdfApp extends StatelessWidget {
  const SmartPdfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart PDF Viewer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const PdfViewerScreen(),
      },
    );
  }
}
