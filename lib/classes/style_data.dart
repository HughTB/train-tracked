import 'package:flutter/material.dart';

class StyleData {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      surface: Color(0xFFF0F0F0),
      primary: Color(0xFF8635E3),
      secondary: Color(0xFFA76CEB),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      indicatorColor: Color(0xFF8635E3),
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      surface: Color(0xFF242424),
      inverseSurface: Color(0xFFFFFFFF),
      onSurface: Color(0xFFFFFFFF),
      primary: Color(0xFF8635E3),
      inversePrimary: Color(0xFFFFFFFF),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFFA76CEB),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF8635E3),
      foregroundColor: Color(0xFFFFFFFF),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      indicatorColor: Color(0xFF8635E3),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Color(0xFFFFFFFF),
    ),
  );
}