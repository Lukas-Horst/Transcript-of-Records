// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppTheme {
  final bool lightMode;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;

  AppTheme({required this.lightMode, required this.primaryColor,
    required this.secondaryColor, required this.tertiaryColor});
}

class AppThemeNotifier extends StateNotifier<AppTheme> {

  AppThemeNotifier() : super(AppTheme(lightMode: true,
      primaryColor: Colors.white, secondaryColor: Color(0xFF76E7F3),
      tertiaryColor: Color(0xFF1707fa)));

  void changeColor(bool lightMode) {
    state = AppTheme(lightMode: lightMode,
        primaryColor: getPrimaryColor(lightMode),
        secondaryColor: getSecondaryColor(lightMode),
        tertiaryColor: getTertiaryColor(lightMode)
    );
  }

  Color getPrimaryColor(bool lightMode) {
    return lightMode ? Colors.white : Colors.grey.shade700;
  }

  Color getSecondaryColor(bool lightMode) {
    return lightMode ? Color(0xFF76E7F3) : Color(0xFF1707fa);
  }

  Color getTertiaryColor(bool lightMode) {
    return lightMode ? Color(0xFF1707fa) : Color(0xFF76E7F3);
  }
}