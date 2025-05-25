import 'package:flutter/material.dart';
import 'package:snapfig/shared/services/pdf_core/provider/pdf_provider.dart';

class InheritedPDFProviderWidget extends InheritedWidget {
  final PDFProvider provider;

  const InheritedPDFProviderWidget({
    super.key,
    required this.provider,
    required super.child,
  });

  static InheritedPDFProviderWidget? maybeOf(BuildContext context) {
    return context.findAncestorWidgetOfExactType<InheritedPDFProviderWidget>();
  }

  static InheritedPDFProviderWidget of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No PDFProviderInheritedWidget found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InheritedPDFProviderWidget oldWidget) =>
      true;
}
