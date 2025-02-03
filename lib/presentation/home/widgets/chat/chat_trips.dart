import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_share/business_logic/trips/trips_cubit.dart';
import 'package:ride_share/core/routing/routes.dart';
import 'package:ride_share/core/shared/functions/functions.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences_keys.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/shared/widgets/custom_text_button.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/core/themes/images.dart';

class ChatTrips extends StatelessWidget {
  const ChatTrips({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<TripsCubit>();
    return BlocConsumer<TripsCubit, TripsState>(
      listener: (context, state) {
        if (state is SuccessSaveTripFeedBackAppState) {
          customSnackBar(
            context: context,
            text: 'تم إضافة تقييمك بنجاح على الرحلة',
            color: ColorsManager.mainColor,
          );

          cubit.feedBackRate = 0;
          cubit.feedBackNotesController.clear();
        }
      },
      builder: (context, state) {
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
              text: 'اختر رحلتك وابدأ المحادثة',
              fontSize: 16.00.sp,
              fontFamily: FontManager.bold,
              color: ColorsManager.white,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: cubit.chatTrips.isEmpty
                ? const Center(child: CircularProgressIndicator.adaptive())
                : ListView.builder(
                    itemCount: cubit.chatTrips.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomText(
                                  text: cubit.chatTrips[index].tripDate!
                                      .substring(0, 10),
                                  fontFamily: FontManager.bold,
                                  color: Colors.grey,
                                  fontSize: 15.sp,
                                ),
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.trip_origin,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 10.w),
                                  CustomText(
                                    text: "رقم الرحلة",
                                    fontFamily: FontManager.bold,
                                    fontSize: 16.sp,
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: 100.w,
                                    height: 35.h,
                                    decoration: BoxDecoration(
                                      color: ColorsManager.secondaryColor,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Center(
                                      child: CustomText(
                                        text: '${cubit.chatTrips[index].id}',
                                        color: ColorsManager.white,
                                        fontSize: 20.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    ImagesManagers.governorate,
                                    height: 25.h,
                                  ),
                                  SizedBox(width: 10.w),
                                  CustomText(
                                    text: "عدد الركاب",
                                    fontFamily: FontManager.bold,
                                    fontSize: 16.sp,
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: 100.w,
                                    height: 35.h,
                                    decoration: BoxDecoration(
                                      color: ColorsManager.secondaryColor,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Center(
                                      child: CustomText(
                                        text:
                                            '${cubit.chatTrips[index].numPassengers}',
                                        color: ColorsManager.white,
                                        fontSize: 20.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              Container(
                                width: double.infinity.w,
                                height: 35.h,
                                decoration: BoxDecoration(
                                  color: ColorsManager.secondaryColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Center(
                                  child: CustomText(
                                    text:
                                        '( ${cubit.chatTrips[index].startProvince}, ${cubit.chatTrips[index].startDistrict} ) من ',
                                    fontSize: 14.sp,
                                    color: ColorsManager.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.h),
                              Container(
                                width: double.infinity.w,
                                height: 35.h,
                                decoration: BoxDecoration(
                                  color: ColorsManager.secondaryColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Center(
                                  child: CustomText(
                                    text:
                                        '( ${cubit.chatTrips[index].endProvince}, ${cubit.chatTrips[index].endDistrict} ) إلى ',
                                    fontSize: 14.sp,
                                    color: ColorsManager.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: state is LoadingSaveTripFeedBackAppState
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : CustomTextButton(
                                        text: 'تحدث مع الإدارة',
                                        onPressed: () {
                                          SharedPreferencesService.saveData(
                                            key: SharedPreferencesKeys
                                                .saveChatTripId,
                                            value: cubit.chatTrips[index].id,
                                          );

                                          Navigator.pushNamed(context,
                                              Routes.chatWithAdminTrip);
                                          cubit.getCustomConversation(
                                              id: cubit.chatTrips[index].id!);
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
