import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_share/business_logic/auth/auth_cubit.dart';
import 'package:ride_share/business_logic/home/home_cubit.dart';
import 'package:ride_share/core/routing/routes.dart';
import 'package:ride_share/core/shared/functions/functions.dart';
import 'package:ride_share/core/shared/widgets/custom_button.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/shared/widgets/custom_text_button.dart';
import 'package:ride_share/core/shared/widgets/custom_text_form_field.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/core/themes/images.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AuthCubit>();
    var loginFormKey = GlobalKey<FormState>();
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
                  child: BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is SuccessLoginAppState) {
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.homeScreen,
                        );
                        customSnackBar(
                          context: context,
                          text: state.generalUserModel.message ??
                              'تم تسجيل الدخول بنجاح',
                          color: ColorsManager.mainColor,
                        );
                        cubit.senFcmToken();
                        context.read<HomeCubit>().getUserProfileData();
                        cubit.loginEmailController.clear();
                        cubit.loginPasswordController.clear();
                      }
                      if (state is ErrorLoginAppState) {
                        customSnackBar(
                          context: context,
                          text:
                              'حدث خطأ، يرجى مراجعة بياناتك والمحاولة مرة أخرى',
                          color: ColorsManager.red,
                        );
                      }
                    },
                    builder: (context, state) {
                      return Form(
                        key: loginFormKey,
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              ImagesManagers.carLogo,
                              height: 170.h,
                              width: double.infinity.w,
                            ),
                            SizedBox(height: 10.0.h),
                            CustomText(
                              text: 'مرحبًا بك، قم بتسجيل الدخول',
                              fontSize: 18.0.sp,
                              fontFamily: FontManager.bold,
                            ),
                            const CustomText(
                              text: 'سعداء دائمًا بتسجيلك',
                              color: ColorsManager.grey,
                            ),
                            SizedBox(height: 30.0.h),
                            CustomTextFormField(
                              hintText: 'البريد الإلكتروني',
                              prefixIcon: SvgPicture.asset(
                                ImagesManagers.mail,
                                height: 10.h,
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'من فضلك هذا الحقل مطلوب';
                                } else if (!cubit.emailRegex.hasMatch(value)) {
                                  return 'من فضلك أدخل بريدًا صحيحًا';
                                }
                                return null;
                              },
                              controller: cubit.loginEmailController,
                              inputType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 20.0.h),
                            CustomTextFormField(
                              hintText: 'كلمة المرور',
                              prefixIcon: SvgPicture.asset(
                                ImagesManagers.lock,
                                height: 10.h,
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'من فضلك هذا الحقل مطلوب';
                                }
                                return null;
                              },
                              obscureText: cubit.loginPasswordObscureText,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  cubit.changeVisibilityTrueOrFalse(
                                    currentVisibility:
                                        cubit.loginPasswordObscureText,
                                    updateVisibility: (value) {
                                      cubit.loginPasswordObscureText = value;
                                    },
                                  );
                                },
                                icon: SvgPicture.asset(
                                  cubit.loginPasswordObscureText == true
                                      ? ImagesManagers.visibility
                                      : ImagesManagers.visibilityOff,
                                  height: 30.h,
                                ),
                              ),
                              controller: cubit.loginPasswordController,
                              inputType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 10.0.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: CustomTextButton(
                                text: 'نسيت كلمة المرور؟',
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: ColorsManager.white,
                                      title: const CustomText(
                                          text: 'قم بإدخال بريدك الإلكتروني'),
                                      content: Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                              hintText: 'البريد الإلكتروني',
                                              prefixIcon: SvgPicture.asset(
                                                ImagesManagers.mail,
                                                height: 10.00.h,
                                              ),
                                              controller: cubit
                                                  .forgetPasswordEmailController,
                                              inputType:
                                                  TextInputType.emailAddress,
                                            ),
                                          )
                                        ],
                                      ),
                                      actions: [
                                        CustomTextButton(
                                          text: 'تراجع',
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        CustomTextButton(
                                          text: 'إرسال',
                                          onPressed: () {
                                            if (cubit
                                                    .forgetPasswordEmailController
                                                    .text
                                                    .isEmpty ||
                                                !cubit.emailRegex.hasMatch(cubit
                                                    .forgetPasswordEmailController
                                                    .text)) {
                                              customSnackBar(
                                                  context: context,
                                                  text: cubit
                                                          .forgetPasswordEmailController
                                                          .text
                                                          .isEmpty
                                                      ? 'من فضلك أدخل البريد الإلكتروني'
                                                      : 'أدخل بريدًا إلكترونيًا صحيحًا',
                                                  color: ColorsManager.red);
                                            } else {
                                              cubit.forgetPassword();
                                              Navigator.pop(context);
                                              cubit
                                                  .forgetPasswordEmailController
                                                  .clear();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 20.0.h),
                            state is LoadingLoginAppState
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : CustomButton(
                                    text: 'تسجيل الدخول',
                                    onPressed: () {
                                      if (loginFormKey.currentState!
                                          .validate()) {
                                        cubit.login();
                                      }
                                    },
                                  ),
                            SizedBox(height: 20.0.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CustomText(text: 'ليس لديك حساب؟'),
                                CustomTextButton(
                                  text: 'سجل الآن',
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.mainRegister,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
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
