import 'package:flutter/material.dart';

final ThemeData lightMode = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
      primary: const Color.fromARGB(255, 255, 72, 0),
      onPrimaryContainer: const Color.fromARGB(255, 255, 232, 222),
      secondary: Colors.grey[300]!,
      onSecondaryContainer: const Color.fromARGB(255, 240, 240, 240),
      surface: Colors.white,
      onPrimary: Colors.black,
      outlineVariant: Colors.black12,
      onSecondary: Colors.black,
      onTertiary: Colors.white,
      tertiary: const Color.fromARGB(255, 243, 243, 243),
      onTertiaryContainer: Color.fromARGB(255, 209, 209, 209)),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.grey),
  ),
);

final ThemeData darkMode = ThemeData(
  scaffoldBackgroundColor: Colors.black,
  colorScheme: ColorScheme.dark(
      primary: const Color.fromARGB(255, 255, 72, 0),
      onPrimaryContainer: const Color.fromARGB(255, 252, 178, 148),
      secondary: Colors.grey[800]!,
      outlineVariant: const Color.fromARGB(179, 66, 66, 66),
      onSecondaryContainer: const Color.fromARGB(255, 40, 40, 40),
      surface: Colors.grey[900]!,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.black,
      tertiary: const Color.fromARGB(255, 31, 31, 31),
      onTertiaryContainer: Color.fromARGB(255, 32, 32, 32)),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.grey),
  ),
);
