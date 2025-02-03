import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_share/business_logic/auth/auth_cubit.dart';
import 'package:ride_share/business_logic/trips/trips_cubit.dart';
import 'package:ride_share/core/shared/functions/functions.dart';
import 'package:ride_share/core/shared/widgets/custom_button.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/presentation/home/widgets/trips/widgets/group/group_passenger_trip_details.dart';
import 'package:ride_share/presentation/home/widgets/trips/widgets/group/group_trip_destination_point.dart';
import 'package:ride_share/presentation/home/widgets/trips/widgets/group/group_trip_details.dart';
import 'package:ride_share/presentation/home/widgets/trips/widgets/group/group_trip_meeting_point.dart';
import 'package:ride_share/presentation/home/widgets/trips/widgets/group/group_trip_summary_confirmation.dart';

class MainGroupTrip extends StatefulWidget {
  const MainGroupTrip({super.key});

  @override
  State<MainGroupTrip> createState() => _MainGroupTripState();
}

class _MainGroupTripState extends State<MainGroupTrip> {
  Widget buildStepContent() {
    var cubit = context.read<TripsCubit>();

    switch (cubit.buildNewGroupTripCurrentStep) {
      case 0:
        return const GroupTripMeetingPoint();
      case 1:
        return const GroupTripDestinationPoint();
      case 2:
        return const GroupTripDetails();
      case 3:
        return const GroupPassengerTripDetails();
      case 4:
        return const GroupTripSummaryConfirmation();

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
    var cubit = context.read<TripsCubit>();

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
          text: 'قم بالإنضمام لرحلة جماعية',
          fontSize: 16.00.sp,
          fontFamily: FontManager.bold,
          color: ColorsManager.white,
        ),
      ),
      body: BlocConsumer<TripsCubit, TripsState>(
        listener: (context, state) {
          Navigator.pop(context);
          cubit.groupTripMeetingPointJoinController.clear();
          cubit.groupTripMeetingPointSelectedLocationGovernorate = null;
          cubit.groupTripMeetingPointSelectedLocationDistrict = null;
          cubit.groupTripMeetingPointSelectedLocationSubDistrict = null;
          cubit.groupTripMeetingPointLatLng = null;
          cubit.groupTripMeetingPointAddress = null;

          cubit.groupTripDestinationPointSelectedLocationGovernorate = null;
          cubit.groupTripDestinationPointSelectedLocationDistrict = null;
          cubit.groupTripDestinationPointSelectedLocationSubDistrict = null;
          cubit.groupTripDestinationPointLatLng = null;
          cubit.groupTripDestinationPointAddress = null;
          cubit.groupTripSeatsListSelectedValue = null;
          cubit.groupTripSelectDate.clear();
          cubit.groupTripDistance = null;
          cubit.groupTripDuration = null;
          cubit.groupTripSelectTimeFrom.clear();
          cubit.groupTripSelectTimeTo.clear();
          cubit.groupTripStartingPrice = null;
          cubit.groupTripGenderSelectedValue = null;
          cubit.groupTripSelectedSquares.clear();
          cubit.groupHasChildren = false;

          cubit.buildNewGroupTripCurrentStep = 0;
          customSnackBar(
            context: context,
            text: 'تم إنشاء رحلة بنجاح',
            color: ColorsManager.mainColor,
          );
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
                    value: cubit.groupProgressValue(),
                  ),
                  SizedBox(height: 20.00.h),
                  buildStepContent(),
                  SizedBox(height: 20.00.h),
                  Row(
                    children: [
                      cubit.buildNewGroupTripCurrentStep == 0
                          ? const SizedBox()
                          : CustomButton(
                              text: 'الرجوع',
                              onPressed: () {
                                setState(() {
                                  cubit.groupPreviousStep();
                                });
                              },
                            ),
                      const Spacer(),
                      cubit.buildNewGroupTripCurrentStep != 4
                          ? CustomButton(
                              text: 'التالي',
                              onPressed: () {
                                // if true next step
                                if (cubit.checkGroupTripValid()) {
                                  setState(() {
                                    cubit.groupNextStep();
                                    if (cubit.buildNewGroupTripCurrentStep ==
                                        2) {
                                      cubit.fetchDistanceAndDuration(
                                          cubit.groupTripMeetingPointLatLng!,
                                          cubit
                                              .groupTripDestinationPointLatLng!);
                                    }
                                  });
                                }
                                // else show message
                                else {
                                  // meeting point handler
                                  if (cubit.buildNewGroupTripCurrentStep == 0) {
                                    if (cubit.groupTripMeetingPointLatLng ==
                                            null ||
                                        cubit.groupTripMeetingPointAddress ==
                                            null) {
                                      customSnackBar(
                                        context: context,
                                        text:
                                            'من فضلك اختر قم بوضع نقطة الإلتقاء على الخريطة',
                                        color: ColorsManager.red,
                                      );
                                    }
                                  }
                                  // destination point handler
                                  else if (cubit.buildNewGroupTripCurrentStep ==
                                      1) {
                                    {
                                      if (cubit.groupTripDestinationPointLatLng ==
                                              null ||
                                          cubit.groupTripDestinationPointAddress ==
                                              null) {
                                        customSnackBar(
                                          context: context,
                                          text:
                                              'من فضلك اختر قم بوضع نقطة الوصول على الخريطة',
                                          color: ColorsManager.red,
                                        );
                                      }
                                    }
                                  }
                                  // time and seat handler
                                  else if (cubit.buildNewGroupTripCurrentStep ==
                                      2) {
                                    {
                                      if (cubit
                                          .groupTripSelectedSquares.isEmpty) {
                                        customSnackBar(
                                          context: context,
                                          text: 'برجاء اختيار المقاعد',
                                          color: ColorsManager.red,
                                        );
                                      }
                                    }
                                  }
                                  // passengers data handler
                                  else if (cubit.buildNewGroupTripCurrentStep ==
                                      3) {}
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
                                    cubit.postTripGroup();
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
