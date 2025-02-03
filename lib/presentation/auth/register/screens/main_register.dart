import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_share/business_logic/auth/auth_cubit.dart';
import 'package:ride_share/core/shared/functions/functions.dart';
import 'package:ride_share/core/shared/widgets/custom_button.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/presentation/auth/register/screens/register.dart';
import 'package:ride_share/presentation/auth/register/screens/register_map.dart';

class MainRegister extends StatefulWidget {
  const MainRegister({super.key});

  @override
  State<MainRegister> createState() => _MainRegisterState();
}

class _MainRegisterState extends State<MainRegister> {
  Widget buildStepContent() {
    var cubit = context.read<AuthCubit>();

    switch (cubit.buildRegisterCurrentStep) {
      case 0:
        return const RegisterScreen();
      case 1:
        return const RegisterMap();
      default:
        return const Center(
          child: CustomText(
            text: 'Unknown Step',
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AuthCubit>();

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
          text: 'قم بتسجيل حساب جديد',
          fontSize: 16.00.sp,
          fontFamily: FontManager.bold,
          color: ColorsManager.white,
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is SuccessRegisterAppState) {
            cubit.registerProfileImage = null;
            cubit.registerFNameController.clear();
            cubit.registerLNameController.clear();
            cubit.registerEmailController.clear();
            cubit.registerPasswordController.clear();
            cubit.registerConfirmPasswordController.clear();
            cubit.registerPhoneController.clear();
            cubit.registerWhatsAppController.clear();
            cubit.registerLatLng = null;
            cubit.registerAddress = null;
            cubit.addressDescriptiveRegister.clear();
            cubit.registerGovernorateController.clear();
            cubit.registerResidentialAreaController.clear();
            cubit.registerNeighborhoodController.clear();
            cubit.registerStreetController.clear();
            cubit.registerBuildingController.clear();
            cubit.registerDistinctiveMarkController.clear();
            cubit.buildRegisterCurrentStep = 0;
            cubit.registerSelectedLocationGovernorate = null;
            cubit.registerSelectedLocationDistrict = null;
            cubit.registerSelectedLocationSubDistrict = null;
            Navigator.pop(context);

            customSnackBar(
              context: context,
              text: 'تم إنشاء حساب بنجاح',
              color: ColorsManager.mainColor,
            );
          }
          if (state is ErrorRegisterAppState) {
            customSnackBar(
              context: context,
              text: 'حدث خطأ يرجى المحاولة مرة أخرى',
              color: ColorsManager.red,
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.00.w,
              vertical: 16.00.h,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20.00.h),
                  LinearProgressIndicator(
                    value: cubit.progressValue(),
                  ),
                  SizedBox(height: 20.00.h),
                  buildStepContent(),
                  SizedBox(height: 20.00.h),
                  Row(
                    children: [
                      cubit.buildRegisterCurrentStep == 0
                          ? const SizedBox()
                          : CustomButton(
                              text: 'الرجوع',
                              onPressed: () {
                                setState(() {
                                  cubit.previousStep();
                                });
                              },
                            ),
                      const Spacer(),
                      cubit.buildRegisterCurrentStep != 1
                          ? CustomButton(
                              text: 'التالي',
                              onPressed: () {
                                if (cubit.checkRegisterValid()) {
                                  setState(() {
                                    cubit.nextStep();
                                  });
                                } else {
                                  if (cubit.registerPasswordController.text !=
                                      cubit.registerConfirmPasswordController
                                          .text) {
                                    customSnackBar(
                                      context: context,
                                      text: 'كلمتا المرور غير متطابقتين',
                                      color: ColorsManager.red,
                                    );
                                  }
                                }
                              },
                            )
                          : state is LoadingRegisterAppState
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : CustomButton(
                                  text: 'إرسال',
                                  onPressed: () {
                                    if (cubit.checkRegisterValid()) {
                                      cubit.register();
                                    } else {
                                      if (cubit.buildRegisterCurrentStep == 1 &&
                                          cubit.registerLatLng == null) {
                                        customSnackBar(
                                          context: context,
                                          text: 'قم بإضافة عنوانك على الخريطة',
                                          color: ColorsManager.red,
                                        );
                                      }
                                    }
                                  },
                                ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
