import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

   const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = ColorsManager.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.00.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF142427).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: InkWell(
          onTap: () {
            onPressed();
          },
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.00.w),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0.sp,
                fontFamily: FontManager.regular,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
