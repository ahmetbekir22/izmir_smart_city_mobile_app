import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF4A90E2), // Modern blue (soft blue)
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF4A90E2), // Blue for app bar background
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF4A90E2), // Blue as primary color
    secondary: Color(0xFF26B0A2), // Light teal accent
    onPrimary: Colors.white, // White text/icons on primary
    surface: Color(0xFFF4F6F9), // Light grey surface color
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black87), // Dark text for body
    bodyMedium: TextStyle(color: Colors.black54), // Medium grey text
    titleLarge: TextStyle(
      color: Color(0xFF4A90E2), // Blue for titles
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(color: Colors.black45), // Lighter grey for small text
    labelMedium: TextStyle(color: Colors.black54), // Slightly lighter caption
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF4A90E2), // Blue button color
    textTheme: ButtonTextTheme.primary,
  ),
  cardTheme: const CardTheme(
    color: Colors.white, // White background for cards
    elevation: 5,
    shadowColor: Color(0xFFB0BEC5), // Light grey shadow for cards
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF4A90E2), // Blue for icons
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF4F6F9), // Light grey input field background
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF4A90E2)), // Blue border for inputs
    ),
    hintStyle: TextStyle(color: Colors.black38), // Light grey hint text color
  ),
);
