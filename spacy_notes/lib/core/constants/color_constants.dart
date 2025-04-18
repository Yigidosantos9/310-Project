import 'package:flutter/material.dart';

class AppColors {
  // General color palet

  // This part is for color scheme in the material app
  // If you want to change color scheme just change in here
  // so this changes affect the entire application

  // primary Color of the app
  static const Color primary = Color(0xFF0C0C0C);
  // Color that on the primary color (Texts, icons ...)
  static const Color onPrimary = Color(0xFFD9D9D9);

  // Secondary color of the app
  static const Color secondary = Color(0xFFF7931B);
  // Color that on the secondary color (Texts, icons ...)
  static const Color onSecondary = Colors.white;

  // General background color
  static const Color background = Color(0xFF060B36);

  // General error colors
  static const Color error = Colors.redAccent;
  static const Color onError = Colors.white;

  // General surface theme
  static const Color surface = Color(0xFF0C0C0C);
  static const Color onSurface = Colors.white70;

  // General app theme (dark or bright now)
  static const Brightness brightness = Brightness.dark;

  // General colors for the app
  static const Color mainButtonColor = Color(0xFF8C12DC);
  static const Color secondaryButtonColor = Color(0xFFC4C4C4);
  static const Color iconColor = Color(0xFFf19ddc);
  static const Color selectedTaskColor = Color(0xFFD9D9D9);
  static const Color unselectedTaskColor = Color(0xFF8C898E);

  static const Color mainTextColor = Color(0xFFFFFFFF);
  static const Color grayTextColor = Color(0xFFD9D9D9);
  static const Color darkSubTextColor = Color(0xFF5A5A5A);
  static const Color lightSubTextColor = Color(0xFFC4C4C4);

  static const Color appBarColor = Color.fromARGB(255, 17, 1, 37);

  static const Color lightGrayBackgroundColor = Color(0xFFF3F3F3);
  // With this you can use this class without create an instance
  AppColors._();
}
