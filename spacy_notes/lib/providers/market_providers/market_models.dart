// lib/models/market_models.dart
import 'package:flutter/material.dart';

class Planet {
  final String title;
  final String subTitle;
  final String imagePath;
  final String price;

  Planet({required this.title, required this.subTitle, required this.imagePath, required this.price});
}

class ProfilePicture {
  final String title;
  final String imagePath;
  final String price;

  ProfilePicture({required this.title, required this.imagePath, required this.price});
}

class ColorPalette {
  final String title;
  final String subTitle;
  final List<Color> gradientColors;
  final Color circleBorderColor;
  final Color circleFillColor;

  ColorPalette({
    required this.title,
    required this.subTitle,
    required this.gradientColors,
    required this.circleBorderColor,
    required this.circleFillColor,
  });
}
