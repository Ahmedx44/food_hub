import 'package:flutter/material.dart';

final ThemeData lightMode = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: const Color.fromARGB(255, 255, 72, 0),
    secondary: Colors.grey[400]!,
    surface: Colors.white,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onTertiary: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.grey),
  ),
);

final ThemeData darkMode = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 18),
  colorScheme: ColorScheme.dark(
    primary: const Color.fromARGB(255, 255, 72, 0),
    secondary: Colors.grey[700]!,
    surface: const Color.fromARGB(255, 30, 30, 30),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onTertiary: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.grey),
  ),
);
