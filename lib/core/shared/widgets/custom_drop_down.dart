import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';

class CustomDropDownButton<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final T? value;
  final String? hintText;
  final String? validatorText;
  final Widget? hint;
  final Widget? prefixIcon;
  final TextStyle? style;

  const CustomDropDownButton({
    super.key,
    this.items,
    this.onChanged,
    this.value,
    this.hintText,
    this.validatorText,
    this.hint,
    this.prefixIcon,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    InputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.00.r),
      borderSide: BorderSide(
        color: ColorsManager.mainColor,
        width: 1.0.w,
      ),
    );
    InputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(
        color: ColorsManager.grey,
        width: 1.0.w,
      ),
    );
    InputBorder errorBorderColor = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(
        color: ColorsManager.red,
        width: 1.0.w,
      ),
    );
    return DropdownButtonFormField(
      items: items,
      onChanged: onChanged,
      value: value,
      validator: (value) {
        if (value == null || value == '') {
          return validatorText;
        }
        return null;
      },
      isExpanded: true,
      hint: hint,
      style: style,
      padding: EdgeInsets.zero,
      alignment: AlignmentDirectional.centerStart,
      decoration: InputDecoration(
        labelText: hintText,
        prefixIcon: prefixIcon,
        labelStyle: TextStyle(
          fontSize: 16.sp,
          fontFamily: FontManager.bold,
        ),
        border: border,
        contentPadding: EdgeInsetsDirectional.only(
          start: 12.w,
          end: 4.w,
        ),
        focusedBorder: focusedBorder,
        enabledBorder: border,
        disabledBorder: border,
        errorBorder: errorBorderColor,
        errorStyle: TextStyle(
          color: ColorsManager.red,
          fontSize: 10.00.sp,
          fontFamily: FontManager.regular,
        ),
      ),
      iconSize: 40.r,
    );
  }
}
