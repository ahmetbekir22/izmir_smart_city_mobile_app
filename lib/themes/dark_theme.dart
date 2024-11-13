import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color.fromARGB(255, 39, 4, 88), // Purple as primary color
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 32, 5, 69),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color.fromARGB(255, 39, 4, 88),
    secondary: Color(0xFF03DAC6),
    onPrimary: Colors.white,
    surface: Color(0xFF1F1F1F),
    background: Color(0xFF121212),
    onBackground: Colors.white,
    onSurface: Colors.white70,
  ),
  cardTheme: const CardTheme(
    color: Color(0xFF1F1F1F),
    elevation: 5,
    shadowColor: Color.fromARGB(255, 155, 131, 188),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.grey),
    titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
  iconTheme: const IconThemeData(color: Color(0xFF6200EE)),
);
