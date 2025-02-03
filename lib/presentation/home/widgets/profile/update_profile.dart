import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_share/business_logic/home/home_cubit.dart';
import 'package:ride_share/core/shared/functions/functions.dart';
import 'package:ride_share/core/shared/widgets/custom_button.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/shared/widgets/custom_text_form_field.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/core/themes/images.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<HomeCubit>();
    var formKey = GlobalKey<FormState>();
    cubit.updateProfileEmailController.text =
        '${cubit.getUserProfileModel!.body!.email}';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ColorsManager.white,
            size: 20.00,
          ),
        ),
        titleSpacing: 0.00,
        title: CustomText(
          text: 'تعديل الملف الشخصي',
          fontSize: 16.00.sp,
          fontFamily: FontManager.bold,
          color: ColorsManager.white,
        ),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is SuccessUpdateUserProfileAppState) {
            cubit.updateProfileImage = null;
            cubit.updateProfileFNameController.clear();
            cubit.updateProfileLNameController.clear();
            cubit.updateProfilePasswordController.clear();
            cubit.updateProfileConfirmPasswordController.clear();
            cubit.updateProfileWhatsNumberController.clear();
            cubit.updateProfilePhoneNumberController.clear();
            cubit.updateProfileProvinceController.clear();
            cubit.updateProfileDistrictController.clear();
            cubit.updateProfileSubDistrictController.clear();
            cubit.updateProfileStreetController.clear();
            cubit.updateProfileBuildingController.clear();
            cubit.updateProfileLandMarkController.clear();

            cubit.getUserProfileData();
            customSnackBar(
              context: context,
              text: 'تم تعديل البيانات بنجاح',
              color: ColorsManager.mainColor,
            );

            Navigator.pop(context);
          }
          if (state is ErrorUpdateUserProfileAppState) {
            customSnackBar(
              context: context,
              text: 'تأكد من البيانات وقم بالمحاولة مرة أخرى',
              color: ColorsManager.red,
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomText(
                        text: 'تعديل البيانات الشخصية',
                        fontSize: 18.sp,
                      ),
                      SizedBox(height: 20.h),
                      InkWell(
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
                                            cubit.updateProfileImage =
                                                cubit
                                                    .pickImageFromDevice(
                                                  cubit.updateProfileImage,
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
                                            cubit.updateProfileImage =
                                                cubit
                                                    .pickImageFromDevice(
                                                  cubit.updateProfileImage,
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

                        child: Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 70.00.r,
                                backgroundColor: ColorsManager.grey,
                                backgroundImage: cubit.updateProfileImage != null
                                    ? FileImage(
                                        File(cubit.updateProfileImage!.path))
                                    : null,
                                child: cubit.updateProfileImage == null
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
                      SizedBox(height: 20.h),
                      CustomTextFormField(
                        hintText: 'الاسم الأول',
                        prefixIcon: SvgPicture.asset(
                          ImagesManagers.person,
                          height: 10.h,
                        ),
                        controller: cubit.updateProfileFNameController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'من فضلك هذا الحقل مطلوب';
                          }
                          return null;
                        },
                        inputType: TextInputType.name,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextFormField(
                        hintText: 'الاسم الأخير',
                        prefixIcon: SvgPicture.asset(
                          ImagesManagers.person,
                          height: 10.h,
                        ),
                        controller: cubit.updateProfileLNameController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'من فضلك هذا الحقل مطلوب';
                          }
                          return null;
                        },
                        inputType: TextInputType.name,
                      ),
                      SizedBox(height: 20.h),
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
                        controller: cubit.updateProfileEmailController,
                        inputType: TextInputType.emailAddress,
                        readOnly: true,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextFormField(
                        hintText: 'كلمة المرور',
                        prefixIcon: SvgPicture.asset(
                          ImagesManagers.lock,
                          height: 10.h,
                        ),
                        obscureText: cubit.updateProfilePasswordObSecure,
                        suffixIcon: IconButton(
                          onPressed: () {
                            cubit.changeVisibilityTrueOrFalse(
                                currentVisibility:
                                    cubit.updateProfilePasswordObSecure,
                                updateVisibility: (value) {
                                  cubit.updateProfilePasswordObSecure = value;
                                });
                          },
                          icon: SvgPicture.asset(
                            cubit.updateProfilePasswordObSecure == true
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
                        controller: cubit.updateProfilePasswordController,
                        inputType: TextInputType.visiblePassword,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextFormField(
                        hintText: 'تأكيد كلمة المرور',
                        prefixIcon: SvgPicture.asset(
                          ImagesManagers.lock,
                          height: 10.h,
                        ),
                        obscureText:
                            cubit.updateProfileConfirmationPasswordObSecure,
                        suffixIcon: IconButton(
                          onPressed: () {
                            cubit.changeVisibilityTrueOrFalse(
                                currentVisibility: cubit
                                    .updateProfileConfirmationPasswordObSecure,
                                updateVisibility: (value) {
                                  cubit.updateProfileConfirmationPasswordObSecure =
                                      value;
                                });
                          },
                          icon: SvgPicture.asset(
                            cubit.updateProfileConfirmationPasswordObSecure ==
                                    true
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
                        controller:
                            cubit.updateProfileConfirmPasswordController,
                        inputType: TextInputType.visiblePassword,
                      ),
                      SizedBox(height: 20.h),
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
                        controller: cubit.updateProfilePhoneNumberController,
                        inputType: TextInputType.phone,
                      ),
                      SizedBox(height: 20.h),
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
                        controller: cubit.updateProfileWhatsNumberController,
                        inputType: TextInputType.phone,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextFormField(
                        hintText: 'المحافظة',
                        prefixIcon: SvgPicture.asset(
                          ImagesManagers.governorate,
                          height: 10.h,
                        ),
                        controller: cubit.updateProfileProvinceController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'من فضلك هذا الحقل مطلوب';
                          }
                          return null;
                        },
                        inputType: TextInputType.name,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextFormField(
                        hintText: 'المنطقة السكنية',
                        prefixIcon: SvgPicture.asset(
                          ImagesManagers.residentialArea,
                          height: 10.h,
                        ),
                        controller: cubit.updateProfileDistrictController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'من فضلك هذا الحقل مطلوب';
                          }
                          return null;
                        },
                        inputType: TextInputType.name,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextFormField(
                        hintText: 'الحي',
                        prefixIcon: SvgPicture.asset(
                          ImagesManagers.neighborhood,
                          height: 10.h,
                        ),
                        controller: cubit.updateProfileSubDistrictController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'من فضلك هذا الحقل مطلوب';
                          }
                          return null;
                        },
                        inputType: TextInputType.name,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextFormField(
                        hintText: 'الشارع',
                        prefixIcon: SvgPicture.asset(
                          ImagesManagers.street,
                          height: 10.h,
                        ),
                        controller: cubit.updateProfileStreetController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'من فضلك هذا الحقل مطلوب';
                          }
                          return null;
                        },
                        inputType: TextInputType.name,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextFormField(
                        hintText: 'العمارة',
                        prefixIcon: SvgPicture.asset(
                          ImagesManagers.building,
                          height: 10.h,
                        ),
                        controller: cubit.updateProfileBuildingController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'من فضلك هذا الحقل مطلوب';
                          }
                          return null;
                        },
                        inputType: TextInputType.name,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextFormField(
                        hintText: 'علامة مميزة',
                        prefixIcon: SvgPicture.asset(
                          ImagesManagers.distinctiveMark,
                          height: 10.h,
                        ),
                        controller: cubit.updateProfileLandMarkController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'من فضلك هذا الحقل مطلوب';
                          }
                          return null;
                        },
                        inputType: TextInputType.name,
                      ),
                      SizedBox(height: 30.h),
                      state is LoadingUpdateUserProfileAppState
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : CustomButton(
                              text: 'تعديل البيانات',
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  if (cubit.updateProfileImage == null) {
                                    customSnackBar(
                                      context: context,
                                      text: 'قم بإضافة صورة للتعديل',
                                      color: ColorsManager.red,
                                    );
                                  } else if (cubit
                                          .updateProfilePasswordController
                                          .text !=
                                      cubit
                                          .updateProfileConfirmPasswordController
                                          .text) {
                                    customSnackBar(
                                      context: context,
                                      text: 'كلمتا المرور غير متطابقتين',
                                      color: ColorsManager.red,
                                    );
                                  } else {
                                    cubit.updateUserProfileData();
                                  }
                                }
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
