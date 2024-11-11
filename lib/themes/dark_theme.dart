import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF1D1D1D), // A modern deep grey/black for primary
  scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 32, 5, 69), // Slightly lighter dark grey for app bar
    foregroundColor: Colors.white, // White text/icons in app bar
    elevation: 0,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color.fromARGB(255, 39, 4, 88), // Purple as the primary accent color
    secondary: Color(0xFF03DAC6), // Teal for secondary accents
    onPrimary: Colors.white, // White text/icons on primary elements
    surface: Color(0xFF121212), // Same dark background for surfaces (scroll)
  ),
  textTheme: TextTheme(
    bodyLarge: const TextStyle(color: Colors.white), // White text for body
    bodyMedium: TextStyle(color: Colors.grey[400]), // Light grey for secondary text
    titleLarge: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Bold headlines
    bodySmall: const TextStyle(color: Colors.white60), // Lighter text for subtitles
    labelMedium: const TextStyle(color: Colors.white70), // Light text for captions
  ),

  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF6200EE), // Purple buttons
    textTheme: ButtonTextTheme.primary, // White text on buttons
  ),
  cardTheme: const CardTheme(
    color: Color(0xFF1F1F1F), // Dark card background
    elevation: 5, // Slight elevation to create depth
    shadowColor: Color.fromARGB(255, 155, 131, 188), // Purple shadow for card
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF6200EE), // Purple icons
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF333333), // Dark background for input fields
    border: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF6200EE)), // Purple border for inputs
    ),
    hintStyle: TextStyle(color: Colors.grey[500]), // Lighter grey hint text color
  ),
);
