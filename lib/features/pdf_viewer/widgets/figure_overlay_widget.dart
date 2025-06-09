import 'package:flutter/material.dart';
import 'package:snapfig/features/pdf_viewer/models/pdf_viewer_viewmodel.dart';
import 'package:snapfig/shared/services/pdf_core/models/models.dart';

class FigureOverlayWidget extends StatelessWidget {
  final BaseLayout figure;
  final PDFDataViewModel viewModel;

  const FigureOverlayWidget({
    super.key,
    required this.figure,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
