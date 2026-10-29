import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isNavyAccent = true;

  bool get isNavyAccent => _isNavyAccent;

  void toggleTheme() {
    _isNavyAccent = !_isNavyAccent;
    notifyListeners();
  }

  ThemeData get currentTheme {
    final primaryAccent = _isNavyAccent ? const Color(0xFF1E3A8A) : const Color(0xFF0D9488);
    final secondaryAccent = _isNavyAccent ? const Color(0xFF3B82F6) : const Color(0xFF14B8A6);

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF05070A),
      primaryColor: primaryAccent,
      colorScheme: ColorScheme.dark(
        primary: primaryAccent,
        secondary: secondaryAccent,
        surface: const Color(0xFF0F172A),
      ),
      fontFamily: 'Roboto',
    );
  }
}