import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final Widget prefixIcon;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;

  const CustomTextFormField({

    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    required this.inputType,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      onTap: onTap,
      readOnly: readOnly,
      style: const TextStyle(
        fontSize: 16.0,
        fontFamily: FontManager.regular,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorsManager.white,
        labelText: hintText,
        labelStyle: const TextStyle(
          color: ColorsManager.secondaryColor,
          fontFamily: FontManager.regular,
        ),
        errorStyle: TextStyle(
          color: ColorsManager.red,
          fontSize: 10.00.sp,
          fontFamily: FontManager.regular,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.00.w),
          child: prefixIcon,
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.00.w),
          child: suffixIcon,
        ),
        contentPadding:
            EdgeInsets.symmetric(vertical: 10.00.h, horizontal: 20.00.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.00.r),
          borderSide: BorderSide(color: ColorsManager.mainColor, width: 1.00.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.00.r),
          borderSide: BorderSide(color: ColorsManager.mainColor, width: 1.00.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.00.r),
          borderSide: BorderSide(color: ColorsManager.grey, width: 1.0.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.00.r),
          borderSide: BorderSide(color: ColorsManager.red, width: 1.0.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.00.r),
          borderSide: BorderSide(color: ColorsManager.red, width: 1.0.w),
        ),
      ),
    );
  }
}
