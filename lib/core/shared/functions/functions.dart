import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_share/core/routing/routes.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences_keys.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/shared/widgets/custom_text_button.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';

// Function to show Snack Bar
void customSnackBar({
  required BuildContext context,
  required String text,
  required Color color,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.00.sp,
          color: ColorsManager.white,
          fontFamily: FontManager.bold,
        ),
      ),
    ),
  );
}

void logout(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const CustomText(text: 'هل تريد حقًا تسجيل الخروج'),
      actions: [
        CustomTextButton(
          text: 'لا',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CustomTextButton(
          text: 'نعم',
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(
              context,
              Routes.loginScreen,
            );
            SharedPreferencesService.removeData(
              key: SharedPreferencesKeys.userToken,
            );
          },
        ),
      ],
    ),
  );
}
