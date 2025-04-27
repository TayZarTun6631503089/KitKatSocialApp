import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFF2563EB), // Main blue
    secondary: Color(0xFF60A5FA), // Lighter blue
    surface: Color(0xFFF1F5F9), // Very light blue/gray
    background: Color(0xFFEFF6FF), // Lightest blue
    error: Color(0xFFEF4444), // Red for errors
    onPrimary: Colors.white,
    onSecondary: Color(0xFF1E293B), // Deep blue/gray for text
    onSurface: Color(0xFF1E293B),
    onBackground: Color(0xFF1E293B),
    onError: Colors.white,
    tertiary: Color(0xFF93C5FD), // Extra light blue for highlights
    inversePrimary: Color(0xFF1E40AF), // Deep navy
  ),
  scaffoldBackgroundColor: Color(0xFFEFF6FF), // Lightest blue
  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromARGB(255, 73, 155, 255), // Main blue
    foregroundColor: Colors.white,
    elevation: 1,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF60A5FA), // Lighter blue
    foregroundColor: Color(0xFF1E293B), // Dark text/icon
  ),
);
