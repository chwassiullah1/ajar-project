import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme_colors_constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: fMainColor,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return fMainColor; // Fill color for checked state
        }
        return Colors.transparent; // No fill color for unchecked state
      }),
      checkColor:
          WidgetStateProperty.all(Colors.white), // Tick color for checked state
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const BorderSide(
              color: fMainColor); // Border color for checked state
        }
        return const BorderSide(
            color: fMainColor); // Border color for unchecked state
      }),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: fMainColor, // Sets the text color for TextButton
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(fMainColor), // Radio button fill color
    ),
    datePickerTheme: const DatePickerThemeData(
      rangeSelectionBackgroundColor: fMainColor,
      dayStyle: TextStyle(color: Colors.black),
      todayBackgroundColor: WidgetStatePropertyAll(fMainColor),
      todayForegroundColor: WidgetStatePropertyAll(Colors.white),
    ),
    textTheme: _buildTextTheme(),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: fMainColor,
    textTheme: _buildTextTheme(),
  );

  static TextTheme _buildTextTheme() {
    return GoogleFonts.poppinsTextTheme(
      const TextTheme(
        titleLarge: TextStyle(),
        titleMedium: TextStyle(),
        titleSmall: TextStyle(),
        bodyLarge: TextStyle(),
        bodyMedium: TextStyle(),
        bodySmall: TextStyle(),
        headlineLarge: TextStyle(),
        headlineMedium: TextStyle(),
        headlineSmall: TextStyle(),
        displayLarge: TextStyle(),
        displayMedium: TextStyle(),
        displaySmall: TextStyle(),
        labelLarge: TextStyle(),
        labelMedium: TextStyle(),
        labelSmall: TextStyle(),
      ),
    );
  }
}