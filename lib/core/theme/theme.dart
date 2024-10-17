import 'package:flutter/material.dart';

final ThemeData lightMode = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: const Color.fromARGB(255, 255, 72, 0),
    onPrimaryContainer: Color.fromARGB(255, 252, 178, 148),
    secondary: Colors.grey[400]!,
    onSecondaryContainer: Color.fromARGB(255, 240, 240, 240),
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
  scaffoldBackgroundColor: Colors.black,
  colorScheme: ColorScheme.dark(
    primary:
        const Color.fromARGB(255, 255, 72, 0), // Keep primary color the same
    onPrimaryContainer:
        Color.fromARGB(255, 252, 178, 148), // Keep this color as is
    secondary: Colors.grey[800]!, // Darker shade for secondary
    onSecondaryContainer:
        Color.fromARGB(255, 40, 40, 40), // Darker shade for secondary container
    surface: Colors.grey[900]!, // Dark surface color
    onPrimary: Colors.white, // Change onPrimary to white for contrast
    onSecondary: Colors.white, // Change onSecondary to white for contrast
    onTertiary: Colors.black, // Change onTertiary to black for contrast
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white), // White text for body large
    bodyMedium: TextStyle(color: Colors.white), // White text for body medium
    bodySmall: TextStyle(color: Colors.grey), // Keep small text grey
  ),
);
