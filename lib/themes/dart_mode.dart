import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF2563EB), // Main blue
    secondary: Color(0xFF60A5FA), // Lighter blue
    surface: Color(0xFF1E293B), // Deep blue/gray for surfaces
    background: Color(0xFF0F172A), // Almost black blue
    error: Color(0xFFEF4444), // Red for errors
    onPrimary: Colors.white,
    onSecondary: Colors.white, // White text/icons on blue
    onSurface: Color(0xFFEFF6FF), // Lightest blue for text/icons
    onBackground: Color(0xFFEFF6FF),
    onError: Colors.white,
    tertiary: Color(0xFF93C5FD), // Extra light blue for highlights
    inversePrimary: Color(0xFF60A5FA), // Lighter blue as accent
  ),
  scaffoldBackgroundColor: Color(0xFF0F172A), // Deep dark blue
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF1E293B), // Deep blue/gray
    foregroundColor: Colors.white,
    elevation: 1,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF2563EB), // Main blue
    foregroundColor: Colors.white, // White icon
  ),
);
