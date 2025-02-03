import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_share/business_logic/auth/auth_cubit.dart';
import 'package:ride_share/core/routing/routes.dart';
import 'package:ride_share/core/shared/functions/functions.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/shared/widgets/custom_text_form_field.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/core/themes/images.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AuthCubit>();
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is SuccessRegisterAppState) {
                Navigator.pushReplacementNamed(
                  context,
                  Routes.loginScreen,
                );
                customSnackBar(
                  context: context,
                  text: 'تم إنشاء الحساب بنجاح',
                  color: ColorsManager.mainColor,
                );
                cubit.registerProfileImage = null;
                cubit.registerFNameController.clear();
                cubit.registerLNameController.clear();
                cubit.registerEmailController.clear();
                cubit.registerPasswordController.clear();
                cubit.registerConfirmPasswordController.clear();
                cubit.registerPhoneController.clear();
                cubit.registerWhatsAppController.clear();
                cubit.registerAddress = null;
                cubit.registerLatLng = null;
                cubit.registerGovernorateController.clear();
                cubit.registerResidentialAreaController.clear();
                cubit.registerNeighborhoodController.clear();
                cubit.registerStreetController.clear();
                cubit.registerBuildingController.clear();
                cubit.registerDistinctiveMarkController.clear();
              }
              if (state is ErrorRegisterAppState) {
                customSnackBar(
                  context: context,
                  text: 'حدث خطأ، يرجى مراجعة بياناتك',
                  color: ColorsManager.red,
                );
                customSnackBar(
                  context: context,
                  text: 'من الممكن أن يكون العنوان مستخدمًا',
                  color: ColorsManager.red,
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: cubit.registerFormKey,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      ImagesManagers.carLogo,
                      height: 170.h,
                      width: double.infinity.w,
                    ),
                    CustomText(
                      text: 'مرحبًا بك، يبدو أنها المرة الأولى',
                      fontSize: 18.0.sp,
                      fontFamily: FontManager.bold,
                    ),
                    const CustomText(
                      text: 'سعداء دائمًا بتسجيلك',
                      color: ColorsManager.grey,
                    ),
                    SizedBox(height: 20.0.h),
                    Center(
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const CustomText(
                                text: 'أضِف صورة شخصية',
                                textAlign: TextAlign.center,
                              ),
                              content: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        ImagePicker()
                                            .pickImage(
                                          source: ImageSource.camera,
                                          imageQuality: 50,
                                        )
                                            .then((value) {
                                          if (value != null) {
                                            cubit.registerProfileImage =
                                                cubit.pickImageFromDevice(
                                                  cubit.registerProfileImage,
                                                  value,
                                                );
                                          }
                                        });
                                        Navigator.pop(context);
                                      },
                                      icon: SvgPicture.asset(
                                        ImagesManagers.camera,
                                        height: 30.h,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        ImagePicker()
                                            .pickImage(
                                          source: ImageSource.gallery,
                                          imageQuality: 50,
                                        )
                                            .then((value) {
                                          if (value != null) {
                                            cubit.registerProfileImage =
                                                cubit.pickImageFromDevice(
                                                  cubit.registerProfileImage,
                                                  value,
                                                );
                                          }
                                        });
                                        Navigator.pop(context);
                                      },
                                      icon: SvgPicture.asset(
                                        ImagesManagers.gallery,
                                        height: 30.h,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 70.00.r,
                              backgroundColor: ColorsManager.grey,
                              backgroundImage: cubit.registerProfileImage != null
                                  ? FileImage(
                                      File(cubit.registerProfileImage!.path))
                                  : null,
                              child: cubit.registerProfileImage == null
                                  ? Center(
                                      child: CustomText(
                                        color: ColorsManager.white,
                                        text: 'لا توجد صورة',
                                        fontSize: 10.00.sp,
                                      ),
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 10.00.h,
                              child: CircleAvatar(
                                backgroundColor:
                                    ColorsManager.white.withOpacity(0.5),
                                radius: 20.00.r,
                                child: SvgPicture.asset(
                                  ImagesManagers.image,
                                  height: 30.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0.h),
                    CustomTextFormField(
                      hintText: 'الاسم الأول',
                      prefixIcon: SvgPicture.asset(
                        ImagesManagers.person,
                        height: 10.h,
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'من فضلك هذا الحقل مطلوب';
                        }
                        return null;
                      },
                      controller: cubit.registerFNameController,
                      inputType: TextInputType.name,
                    ),
                    SizedBox(height: 20.h),
                    CustomTextFormField(
                      hintText: 'الاسم الأخير',
                      prefixIcon: SvgPicture.asset(
                        ImagesManagers.person,
                        height: 10.h,
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'من فضلك هذا الحقل مطلوب';
                        }
                        return null;
                      },
                      controller: cubit.registerLNameController,
                      inputType: TextInputType.name,
                    ),
                    SizedBox(height: 20.0.h),
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
                      controller: cubit.registerEmailController,
                      inputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20.0.h),
                    CustomTextFormField(
                      hintText: 'كلمة المرور',
                      prefixIcon: SvgPicture.asset(
                        ImagesManagers.lock,
                        height: 10.h,
                      ),
                      obscureText: cubit.registerPasswordObscureText,
                      suffixIcon: IconButton(
                        onPressed: () {
                          cubit.changeVisibilityTrueOrFalse(
                              currentVisibility:
                                  cubit.registerPasswordObscureText,
                              updateVisibility: (value) {
                                cubit.registerPasswordObscureText = value;
                              });
                        },
                        icon: SvgPicture.asset(
                          cubit.registerPasswordObscureText == true
                              ? ImagesManagers.visibility
                              : ImagesManagers.visibilityOff,
                          height: 30.h,
                        ),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'من فضلك هذا الحقل مطلوب';
                        } else if (!cubit.passwordRegex.hasMatch(value)) {
                          return 'يجب أن تحتوي كلمة المرور على أحرف أبجدية وألا يقل عن 8';
                        }
                        return null;
                      },
                      controller: cubit.registerPasswordController,
                      inputType: TextInputType.visiblePassword,
                    ),
                    SizedBox(height: 20.0.h),
                    CustomTextFormField(
                      hintText: 'تأكيد كلمة المرور',
                      prefixIcon: SvgPicture.asset(
                        ImagesManagers.lock,
                        height: 10.h,
                      ),
                      obscureText: cubit.registerConfirmPasswordObscureText,
                      suffixIcon: IconButton(
                        onPressed: () {
                          cubit.changeVisibilityTrueOrFalse(
                              currentVisibility:
                                  cubit.registerConfirmPasswordObscureText,
                              updateVisibility: (value) {
                                cubit.registerConfirmPasswordObscureText =
                                    value;
                              });
                        },
                        icon: SvgPicture.asset(
                          cubit.registerConfirmPasswordObscureText == true
                              ? ImagesManagers.visibility
                              : ImagesManagers.visibilityOff,
                          height: 30.h,
                        ),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'من فضلك هذا الحقل مطلوب';
                        } else if (!cubit.passwordRegex.hasMatch(value)) {
                          return 'يجب أن تحتوي كلمة المرور على أحرف أبجدية وألا يقل عن 8';
                        }
                        return null;
                      },
                      controller: cubit.registerConfirmPasswordController,
                      inputType: TextInputType.visiblePassword,
                    ),
                    SizedBox(height: 20.0.h),
                    CustomTextFormField(
                      hintText: 'رقم هاتف',
                      prefixIcon: SvgPicture.asset(
                        ImagesManagers.phone,
                        height: 10.h,
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'من فضلك هذا الحقل مطلوب';
                        } else if (!cubit.egyptPhoneRegExp.hasMatch(value)) {
                          return 'من فضلك أخل رقمًا صحيحًا';
                        }
                        return null;
                      },
                      controller: cubit.registerPhoneController,
                      inputType: TextInputType.phone,
                    ),
                    SizedBox(height: 20.0.h),
                    CustomTextFormField(
                      hintText: 'رقم واتساب',
                      prefixIcon: SvgPicture.asset(
                        ImagesManagers.phone,
                        height: 10.h,
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'من فضلك هذا الحقل مطلوب';
                        } else if (!cubit.egyptPhoneRegExp.hasMatch(value)) {
                          return 'من فضلك أخل رقمًا صحيحًا';
                        }
                        return null;
                      },
                      controller: cubit.registerWhatsAppController,
                      inputType: TextInputType.phone,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
