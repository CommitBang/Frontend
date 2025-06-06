import 'package:flutter/material.dart';

/// A singleton service that handles navigation throughout the app.
/// 
/// This service provides a centralized way to manage navigation without
/// requiring BuildContext, making it easier to navigate from ViewModels
/// and other non-widget classes.
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  /// Global navigator key used to access navigator state from anywhere in the app
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Navigate to a named route with optional arguments
  /// 
  /// [routeName] The name of the route to navigate to
  /// [arguments] Optional arguments to pass to the route
  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  /// Navigate to a widget directly without using named routes
  /// 
  /// [widget] The widget to navigate to
  Future<dynamic> navigateToWidget(Widget widget) {
    return navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (_) => widget),
    );
  }

  /// Navigate to a widget and replace the current route
  /// 
  /// [widget] The widget to navigate to
  Future<dynamic> navigateToWidgetAndReplace(Widget widget) {
    return navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(builder: (_) => widget),
    );
  }

  /// Navigate to a named route and remove all previous routes
  /// 
  /// [routeName] The name of the route to navigate to
  /// [arguments] Optional arguments to pass to the route
  Future<dynamic> navigateToAndRemoveUntil(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Pop the current route and optionally return a result
  /// 
  /// [result] Optional result to return to the previous route
  void goBack([dynamic result]) {
    return navigatorKey.currentState!.pop(result);
  }

  /// Check if it's possible to pop the current route
  /// 
  /// Returns true if there's a route to pop, false otherwise
  bool canGoBack() {
    return navigatorKey.currentState!.canPop();
  }
}