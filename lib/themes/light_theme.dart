import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF4A90E2), // Modern blue (soft blue)
  scaffoldBackgroundColor:
      const Color(0xFFF2F5FA), // Güncellenmiş arka plan rengi
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF4A90E2),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  colorScheme: const ColorScheme.light(
    primary: Color.fromARGB(200, 18, 99, 174),
    secondary: Color(0xFF26B0A2),
    onPrimary: Colors.white,
    surface: Color(0xFFF2F5FA), // Güncellenmiş yüzey rengi
    background: Color(0xFFF2F5FA), // Arka plan rengi
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black54),
    titleLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(color: Colors.black45),
    labelMedium: TextStyle(color: Colors.black54),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF4A90E2),
    textTheme: ButtonTextTheme.primary,
  ),
  cardTheme: const CardTheme(
    color: Colors.white,
    elevation: 5,
    shadowColor: Color(0xFFB0BEC5),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF4A90E2),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF4F6F9),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF4A90E2)),
    ),
    hintStyle: TextStyle(color: Colors.black38),
  ),
);
