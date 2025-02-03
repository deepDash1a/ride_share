import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_share/business_logic/home/home_cubit.dart';
import 'package:ride_share/core/routing/routes.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/core/themes/images.dart';

class Locations extends StatefulWidget {
  const Locations({super.key});

  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  @override
  Widget build(BuildContext context) {
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
          text: 'المواقع',
          fontSize: 16.00.sp,
          fontFamily: FontManager.bold,
          color: ColorsManager.white,
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            ImagesManagers.wallPaper,
            width: double.infinity.w,
            height: double.infinity.h,
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.setLocationScreen,
                              );
                            },
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 16.h),
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      ImagesManagers.newTrip,
                                      height: 40.h,
                                    ),
                                    SizedBox(height: 10.h),
                                    const CustomText(text: 'إضافة موقع'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Routes.getLocationScreen);
                              context.read<HomeCubit>().getLocation();
                            },
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 16.h),
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      ImagesManagers.myTrips,
                                      height: 40.h,
                                    ),
                                    SizedBox(height: 10.h),
                                    const CustomText(text: 'عرض المواقع'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
