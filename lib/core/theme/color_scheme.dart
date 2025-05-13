//color_scheme.dart

import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFE94F1D),
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFFFE2D5),
  onPrimaryContainer: Colors.black,
  secondary: Color(0xFFF46B54),
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFFFEDE9),
  onSecondaryContainer: Colors.black,
  error: Color(0xFFBA1A1A),
  onError: Colors.white,
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Colors.black,
  surface: Colors.white,
  onSurface: Colors.black,
  surfaceContainerHighest: Color(0xFFF3F3F3),
  onSurfaceVariant: Colors.black,
  outline: Color(0xFF9E9E9E),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFF8A65),
  onPrimary: Colors.black,
  primaryContainer: Color(0xFF3A2000),
  onPrimaryContainer: Colors.white,
  secondary: Color(0xFFFFAB91),
  onSecondary: Colors.black,
  secondaryContainer: Color(0xFF401A12),
  onSecondaryContainer: Colors.white,
  error: Color(0xFFFFB4AB),
  onError: Colors.black,
  errorContainer: Color(0xFF8C1D18),
  onErrorContainer: Colors.white,
  surface: Color(0xFF1E1E1E),
  onSurface: Colors.white,
  surfaceContainerHighest: Color(0xFF2D2D2D),
  onSurfaceVariant: Colors.white,
  outline: Color(0xFFBDBDBD),
);