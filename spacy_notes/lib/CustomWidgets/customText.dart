import 'package:flutter/material.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final String fontFamily;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;

  const CustomText({
    super.key,
    required this.text,
    this.maxLines,
    this.fontFamily = 'Jersey',
    this.color = AppColors.darkSubTextColor,
    this.fontSize = 23.0,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? overflow : null,
    );
  }
}