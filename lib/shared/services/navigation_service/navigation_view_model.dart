import 'package:flutter/material.dart';
import 'package:snapfig/features/pdf_viewer/screens/pdf_viewer.dart';
import 'package:snapfig/shared/services/navigation_service/navigation_service.dart';

/// ViewModel for handling navigation in the MVVM pattern.
///
/// This class provides navigation functionality to UI components
/// while keeping the navigation logic separate from the UI layer.
/// It uses NavigationService internally to perform actual navigation.
class NavigationViewModel extends ChangeNotifier {
  final NavigationService _navigationService = NavigationService();

  /// Navigate to the PDF viewer screen
  ///
  /// [path] The path to the PDF file
  /// [isAsset] Whether the PDF is an asset file (default: false)
  void navigateToPdfViewer({required String path, bool isAsset = false}) {
    _navigationService.navigateToWidget(
      PDFViewer(path: path, isAsset: isAsset),
    );
  }

  /// Navigate back to the previous screen
  ///
  /// [result] Optional result to return to the previous screen
  void navigateBack([dynamic result]) {
    if (_navigationService.canGoBack()) {
      _navigationService.goBack(result);
    }
  }

  /// Check if navigation back is possible
  ///
  /// Returns true if there's a previous route to navigate back to
  bool canNavigateBack() {
    return _navigationService.canGoBack();
  }

  /// Navigate to a named route
  ///
  /// [routeName] The name of the route to navigate to
  /// [arguments] Optional arguments to pass to the route
  Future<dynamic> navigateToRoute(String routeName, {Object? arguments}) {
    return _navigationService.navigateTo(routeName, arguments: arguments);
  }
}
