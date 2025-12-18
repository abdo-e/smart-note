import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? _darkTheme : _lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  final ThemeData _lightTheme = ThemeData(
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

  // Dark Theme
  final ThemeData _darkTheme = ThemeData(
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
