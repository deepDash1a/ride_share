import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_share/business_logic/trips/trips_cubit.dart';
import 'package:ride_share/core/routing/routes.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences_keys.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/core/themes/images.dart';

class IndividualOrGroupScreen extends StatefulWidget {
  const IndividualOrGroupScreen({super.key});

  @override
  State<IndividualOrGroupScreen> createState() =>
      _IndividualOrGroupScreenState();
}

class _IndividualOrGroupScreenState extends State<IndividualOrGroupScreen> {
  bool isGroupSelected = false;

  void _toggleGroupMode() {
    setState(() {
      isGroupSelected = SharedPreferencesService.getData(
              key: SharedPreferencesKeys.tripGroupType) ==
          'group';
    });
  }

  String generateRandomId(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#%&0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _toggleGroupMode();

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
          text: 'اختر نوع الرحلة',
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
                              setState(() {
                                SharedPreferencesService.saveData(
                                  key: SharedPreferencesKeys.tripGroupType,
                                  value: 'group',
                                );
                                print(SharedPreferencesService.getData(
                                    key: SharedPreferencesKeys.tripGroupType));
                              });
                            },
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 16.h),
                                child: const CustomText(text: 'مجموعة'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                SharedPreferencesService.saveData(
                                  key: SharedPreferencesKeys.tripGroupType,
                                  value: 'individual',
                                );

                                print(SharedPreferencesService.getData(
                                    key: SharedPreferencesKeys.tripGroupType));
                                context.read<TripsCubit>().groupId = null;
                                Navigator.pushNamed(
                                  context,
                                  Routes.individualTrip,
                                );
                                context
                                    .read<TripsCubit>()
                                    .buildNewGroupTripCurrentStep = 0;
                              });
                            },
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 16.h),
                                child: const CustomText(text: 'فردية'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: isGroupSelected ? 90.h : -100.h,
            right: 16.w,
            child: Row(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    final randomGroupId = generateRandomId(8);
                    context.read<TripsCubit>().groupId = randomGroupId;

                    Navigator.pushNamed(context, Routes.groupTrip);
                    SharedPreferencesService.saveData(
                        key: SharedPreferencesKeys.joinOrCreate,
                        value: 'create');

                    print('Group ID: $randomGroupId');
                  },
                  backgroundColor: ColorsManager.secondaryColor,
                  heroTag: '1',
                  child: SvgPicture.asset(
                    ImagesManagers.join,
                    height: 35.h,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 20.w),
                CustomText(
                  text: 'إنشاء مجموعة جديدة',
                  fontSize: 16.sp,
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: isGroupSelected ? 16.h : -100.h,
            right: 16.w,
            child: Row(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.groupTrip);
                    SharedPreferencesService.saveData(
                        key: SharedPreferencesKeys.joinOrCreate, value: 'join');
                  },
                  backgroundColor: ColorsManager.secondaryColor,
                  heroTag: '2',
                  child: SvgPicture.asset(
                    ImagesManagers.join,
                    height: 35.h,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 20.w),
                CustomText(
                  text: 'انضمام إلى مجموعة',
                  fontSize: 16.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
