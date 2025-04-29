import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
  primaryColor: const Color(0xFF3D5A40),
  hintColor: const Color(0xFFB0B0B0),
  scaffoldBackgroundColor: const Color(0xFFFFF7E9),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF3D5A40),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Color(0xFF3D5A40),
    ),
    headlineMedium: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: Color(0xFF3D5A40),
    ),
    headlineSmall: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Color(0xFF3D5A40),
    ),
    bodyLarge: TextStyle(fontSize: 16.0, color: Color(0xFF3A3A3A)),
    bodyMedium: TextStyle(fontSize: 14.0, color: Color(0xFF3A3A3A)),
    bodySmall: TextStyle(fontSize: 12.0, color: Color(0xFF6F6F6F)),
    labelLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF3D5A40),
    primary: const Color(0xFF3D5A40),
    secondary: const Color(0xFF3A3A3A),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF3D5A40),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF3D5A40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      side: const BorderSide(color: Color(0xFF3D5A40)),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Color(0xFFDADADA)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Color(0xFF3D5A40)),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Colors.red.shade400),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Colors.red.shade600),
    ),
    labelStyle: const TextStyle(color: Color(0xFF3D5A40)),
    hintStyle: TextStyle(color: Colors.grey.shade400),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFDAB89E),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 2.0,
    margin: const EdgeInsets.all(8.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
  ),
  listTileTheme: const ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    iconColor: Color(0xFF3D5A40),
  ),
);
