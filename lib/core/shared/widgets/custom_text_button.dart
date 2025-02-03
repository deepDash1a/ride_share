import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/themes/colors.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  double fontSize;

  final Color? textColor;
  final TextStyle? textStyle;
  final double? horizontalPadding;
  final double? verticalPadding;

  CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fontSize = 16.0,
    this.textColor,
    this.textStyle,
    this.horizontalPadding,
    this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? ColorsManager.mainColor,
        // Default text color
        textStyle: textStyle ??
            const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
      ),
      child: CustomText(
        text: text,
        fontSize: fontSize.sp,
      ),
    );
  }
}
