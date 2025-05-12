import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/pdf_viewer//screens/pdf_viewer_screen.dart';

void main() {
  runApp(const SmartPdfApp()); //snapfig로 수정
}

class SmartPdfApp extends StatelessWidget {
  const SmartPdfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart PDF Viewer', // 이름 수정
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Light/Dark theme 분리 가능
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const PdfViewerScreen(),
    );
  }
}
