// lib/main.dart

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snapfig/features/home/screens/home_widget.dart';
import 'package:snapfig/shared/services/navigation_service/navigation_service.dart';
import 'package:snapfig/shared/services/ocr_core/ocr_core.dart';
import 'package:snapfig/shared/services/pdf_core/pdf_core.dart';
import 'core/theme/theme.dart';

class _DummyOCRProvider extends OCRProvider {
  @override
  Future<OCRResult> process(String imagePath) async {
    return OCRResult();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationCacheDirectory();
  final pdfProvider = await PDFProviderImpl.load(
    ocrProvider: _DummyOCRProvider(),
    dbPath: dir.path,
  );
  runApp(SnapfigApp(pdfProvider: pdfProvider));
}

class SnapfigApp extends StatelessWidget {
  final PDFProvider _pdfProvider;
  final NavigationService _navigationService = NavigationService();

  SnapfigApp({super.key, required PDFProvider pdfProvider})
    : _pdfProvider = pdfProvider;

  @override
  Widget build(BuildContext context) {
    return InheritedPDFProviderWidget(
      provider: _pdfProvider,
      child: MaterialApp(
        title: 'Snapfig',
        theme: lightTheme,
        darkTheme: darkTheme,
        navigatorKey: _navigationService.navigatorKey,
        home: const HomeWidget(),
      ),
    );
  }
}
