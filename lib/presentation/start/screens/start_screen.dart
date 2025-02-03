import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_share/core/routing/routes.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences_keys.dart';
import 'package:ride_share/core/shared/widgets/custom_button.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/core/themes/images.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              ImagesManagers.wallPaper,
              width: double.infinity.w,
              height: double.infinity.h,
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    children: [
                      CustomText(
                        text: 'شارك طريقك الآن',
                        fontSize: 18.sp,
                        fontFamily: FontManager.bold,
                      ),
                      SizedBox(height: 20.h),
                      SvgPicture.asset(
                        ImagesManagers.rideShareLogo,
                      ),
                      SizedBox(height: 20.h),
                      CustomButton(
                        text: 'إبدأ الآن',
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            Routes.loginScreen,
                          );
                          setState(() {
                            SharedPreferencesService.saveData(
                              key: SharedPreferencesKeys.startScreen,
                              value: 'true',
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
