import 'package:flutter/material.dart';

class UiConfig {
  UiConfig._();
  static String get title => 'Tractian';
  static ThemeData get theme => ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff17192D)),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff17192D),
        foregroundColor: Colors.white,
      ));
}
