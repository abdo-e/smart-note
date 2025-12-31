import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false; // false = light mode, true = dark mode
  }

  void toggleTheme() {
    state = !state;
  }

  ThemeData get currentTheme => state ? _darkTheme : _lightTheme;

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF6A5ACD),
    scaffoldBackgroundColor: Color(0xFFF5F5FF),
    colorScheme: ColorScheme.light(
      primary: Color(0xFF6A5ACD),
      secondary: Color(0xFF6A5ACD),
      surface: Colors.white,
      background: Color(0xFFF5F5FF),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF6A5ACD),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF6A5ACD),
      foregroundColor: Colors.white,
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF6A5ACD),
    scaffoldBackgroundColor: Color(0xFF1A1A2E),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF6A5ACD),
      secondary: Color(0xFF6A5ACD),
      surface: Color(0xFF16213E),
      background: Color(0xFF1A1A2E),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF16213E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Color(0xFF16213E),
      elevation: 2,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF6A5ACD),
      foregroundColor: Colors.white,
    ),
  );
}

final themeProvider = NotifierProvider<ThemeNotifier, bool>(() {
  return ThemeNotifier();
});
