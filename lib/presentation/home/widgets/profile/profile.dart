import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_share/business_logic/home/home_cubit.dart';
import 'package:ride_share/core/routing/routes.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/shared/widgets/custom_text_button.dart';
import 'package:ride_share/core/shared/widgets/custom_text_form_field.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/core/themes/images.dart';
import 'package:ride_share/data/api/end_points.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<HomeCubit>();

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
          text: 'الملف الشخصي',
          fontSize: 16.00.sp,
          fontFamily: FontManager.bold,
          color: ColorsManager.white,
        ),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Stack(
            children: [
              Image.asset(
                ImagesManagers.wallPaper,
                width: double.infinity.w,
                height: double.infinity.h,
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0.w,
                    vertical: 16.00.h,
                  ),
                  child: cubit.getUserProfileModel == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: CircleAvatar(
                                  radius: 70.00.r,
                                  backgroundColor: ColorsManager.grey,
                                  backgroundImage: NetworkImage(cubit
                                              .getUserProfileModel!.body!.profileImage ==
                                          null
                                      ? 'https://img.freepik.com/premium-vector/silver-membership-icon-default-avatar-profile-icon-membership-icon-social-media-user-image-vector-illustration_561158-4195.jpg?w=740'
                                      : '${EndPoints.imagesBaseUrl}${cubit.getUserProfileModel!.body!.profileImage}')),
                            ),
                            SizedBox(height: 20.00.h),
                            CustomTextFormField(
                              hintText: 'الاسم الأول',
                              prefixIcon: SvgPicture.asset(
                                ImagesManagers.person,
                                height: 10.h,
                              ),
                              controller: TextEditingController(
                                  text:
                                      '${cubit.getUserProfileModel!.body!.firstName}'),
                              inputType: TextInputType.name,
                              readOnly: true,
                            ),
                            SizedBox(height: 20.00.h),
                            CustomTextFormField(
                              hintText: 'الاسم الأخير',
                              prefixIcon: SvgPicture.asset(
                                ImagesManagers.person,
                                height: 10.h,
                              ),
                              readOnly: true,
                              controller: TextEditingController(
                                  text:
                                      '${cubit.getUserProfileModel!.body!.secondName}'),
                              inputType: TextInputType.name,
                            ),
                            SizedBox(height: 20.00.h),
                            CustomTextFormField(
                              hintText: 'البريد الإلكتروني',
                              prefixIcon: SvgPicture.asset(
                                ImagesManagers.mail,
                                height: 10.h,
                              ),
                              readOnly: true,
                              controller: TextEditingController(
                                  text:
                                      '${cubit.getUserProfileModel!.body!.email}'),
                              inputType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 20.00.h),
                            CustomTextFormField(
                              hintText: 'رقم الواتساب',
                              prefixIcon: SvgPicture.asset(
                                ImagesManagers.phone,
                                height: 10.h,
                              ),
                              readOnly: true,
                              controller: TextEditingController(
                                  text:
                                      '${cubit.getUserProfileModel!.body!.whatsappNumber}'),
                              inputType: TextInputType.phone,
                            ),
                            SizedBox(height: 20.00.h),
                            CustomTextFormField(
                              hintText: 'رقم الهاتف',
                              prefixIcon: SvgPicture.asset(
                                ImagesManagers.phone,
                                height: 10.h,
                              ),
                              readOnly: true,
                              controller: TextEditingController(
                                  text:
                                      '${cubit.getUserProfileModel!.body!.phoneNumber}'),
                              inputType: TextInputType.phone,
                            ),
                            SizedBox(height: 20.00.h),
                            CustomTextFormField(
                              hintText: 'المحافظة',
                              prefixIcon: SvgPicture.asset(
                                ImagesManagers.governorate,
                                height: 10.h,
                              ),
                              readOnly: true,
                              controller: TextEditingController(
                                  text: cubit.getUserProfileModel!.body!
                                          .province ??
                                      'لم يتم إدخال المحافظة'),
                              inputType: TextInputType.text,
                            ),
                            SizedBox(height: 20.00.h),
                            CustomTextFormField(
                              hintText: 'المنطقة السكنية',
                              prefixIcon: SvgPicture.asset(
                                ImagesManagers.residentialArea,
                                height: 10.h,
                              ),
                              readOnly: true,
                              controller: TextEditingController(
                                  text: cubit.getUserProfileModel!.body!
                                          .district ??
                                      'لم يتم إدخال المنطقة السكنية'),
                              inputType: TextInputType.text,
                            ),
                            SizedBox(height: 20.00.h),
                            CustomTextFormField(
                              hintText: 'الحي',
                              prefixIcon: SvgPicture.asset(
                                ImagesManagers.neighborhood,
                                height: 10.h,
                              ),
                              readOnly: true,
                              controller: TextEditingController(
                                  text: cubit.getUserProfileModel!.body!
                                          .subDistrict ??
                                      'لم يتم إدخال الحي'),
                              inputType: TextInputType.text,
                            ),
                            SizedBox(height: 20.00.h),
                            CustomTextFormField(
                              hintText: 'الشارع',
                              prefixIcon: SvgPicture.asset(
                                ImagesManagers.street,
                                height: 10.h,
                              ),
                              readOnly: true,
                              controller: TextEditingController(
                                  text:
                                      cubit.getUserProfileModel!.body!.street ??
                                          'لم يتم إدخال الشارع'),
                              inputType: TextInputType.text,
                            ),
                            SizedBox(height: 20.00.h),
                            CustomTextFormField(
                              hintText: 'العمارة',
                              prefixIcon: SvgPicture.asset(
                                ImagesManagers.building,
                                height: 10.h,
                              ),
                              readOnly: true,
                              controller: TextEditingController(
                                  text: cubit.getUserProfileModel!.body!
                                          .building ??
                                      'لم يتم إدخال العمارة'),
                              inputType: TextInputType.text,
                            ),
                            SizedBox(height: 20.00.h),
                            CustomTextFormField(
                              hintText: 'العلامة المميزة',
                              prefixIcon: SvgPicture.asset(
                                ImagesManagers.distinctiveMark,
                                height: 10.h,
                              ),
                              readOnly: true,
                              controller: TextEditingController(
                                  text: cubit.getUserProfileModel!.body!
                                          .landmark ??
                                      'لم يتم إدخال العلامة المميزة'),
                              inputType: TextInputType.text,
                            ),
                            SizedBox(height: 20.00.h),
                            Center(
                              child: CustomTextButton(
                                text: 'تعديل البيانات',
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Routes.updateProfileScreen);
                                },
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
