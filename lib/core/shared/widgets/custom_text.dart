import 'package:flutter/material.dart';
import 'package:ride_share/core/themes/fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextBaseline? textBaseline;
  final double? height;
  final double? letterSpacing;
  final double? wordSpacing;
  final Locale? locale;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final int? maxLines;
  final TextDirection textDirection;
  final TextWidthBasis textWidthBasis;
  final bool softWrap;

  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.fontFamily = FontManager.bold,
    this.fontSize = 16.00,
    this.fontWeight,
    this.fontStyle,
    this.decoration,
    this.decorationColor,
    this.textBaseline,
    this.height,
    this.letterSpacing,
    this.wordSpacing,
    this.locale,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.center,
    this.maxLines = 4,
    this.textDirection = TextDirection.ltr,
    this.textWidthBasis = TextWidthBasis.parent,
    this.softWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: decoration,
        decorationColor: decorationColor,
        textBaseline: textBaseline,
        height: height,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        locale: locale,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      textDirection: textDirection,
      textWidthBasis: textWidthBasis,
      softWrap: softWrap,
    );
  }
}
