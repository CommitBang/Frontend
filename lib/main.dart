// lib/main.dart

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

      // 기본 진입 화면으로 PdfViewerScreen을 경로 인자와 함께 지정.
      // 실제 서비스시, 로컬 PDF 로드로 바꾸고 싶다면
      // isAsset: false 로 바꾸고
      // path:에 /storage/emulated/0/Download/your.pdf 같은 실제 파일 경로를 넘기면 됩니다.
      home: const PdfViewerScreen(
        path: 'assets/sample_ocr_test.pdf',
        isAsset: true,
      ),
    );
  }
}
