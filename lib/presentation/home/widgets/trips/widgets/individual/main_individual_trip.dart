import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_share/business_logic/trips/trips_cubit.dart';
import 'package:ride_share/core/shared/functions/functions.dart';
import 'package:ride_share/core/shared/widgets/custom_button.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/presentation/home/widgets/trips/widgets/individual/individual_passenger_trip_details.dart';
import 'package:ride_share/presentation/home/widgets/trips/widgets/individual/individual_trip_destination_point.dart';
import 'package:ride_share/presentation/home/widgets/trips/widgets/individual/individual_trip_details.dart';
import 'package:ride_share/presentation/home/widgets/trips/widgets/individual/individual_trip_meeting_point.dart';
import 'package:ride_share/presentation/home/widgets/trips/widgets/individual/individual_trip_summary_confirmation.dart';

class MainIndividualTrip extends StatefulWidget {
  const MainIndividualTrip({super.key});

  @override
  State<MainIndividualTrip> createState() => _MainIndividualTripState();
}

class _MainIndividualTripState extends State<MainIndividualTrip> {
  Widget buildStepContent() {
    var cubit = context.read<TripsCubit>();

    switch (cubit.buildNewIndividualTripCurrentStep) {
      case 0:
        return const IndividualTripMeetingPoint();
      case 1:
        return const IndividualTripDestinationPoint();
      case 2:
        return const IndividualTripDetails();
      case 3:
        return const IndividualPassengerTripDetails();
      case 4:
        return const IndividualTripSummaryConfirmation();

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
          text: 'قم بإدخال تفاصيل رحلتك',
          fontSize: 16.00.sp,
          fontFamily: FontManager.bold,
          color: ColorsManager.white,
        ),
      ),
      body: BlocConsumer<TripsCubit, TripsState>(
        listener: (context, state) {
          if (state is SuccessCreateNewIndividualTripAppState) {
            Navigator.pop(context);
            cubit.individualTripMeetingPointSelectedLocationGovernorate = null;
            cubit.individualTripMeetingPointSelectedLocationDistrict = null;
            cubit.individualTripMeetingPointSelectedLocationSubDistrict = null;
            cubit.individualTripMeetingPointLatLng = null;
            cubit.individualTripMeetingPointAddress = null;

            cubit.individualTripDestinationPointSelectedLocationGovernorate =
                null;
            cubit.individualTripDestinationPointSelectedLocationDistrict = null;
            cubit.individualTripDestinationPointSelectedLocationSubDistrict =
                null;
            cubit.individualTripDestinationPointLatLng = null;
            cubit.individualTripDestinationPointAddress = null;
            cubit.individualTripSeatsListSelectedValue = null;
            cubit.individualTripSelectDate.clear();
            cubit.individualTripDistance = null;
            cubit.individualTripDuration = null;
            cubit.individualTripSelectTimeFrom.clear();
            cubit.individualTripSelectTimeTo.clear();
            cubit.individualTripStartingPrice = null;
            cubit.individualTripBabiesAgeSelectedValue = null;
            cubit.individualTripGenderSelectedValue = null;
            cubit.individualTripSelectedSquares.clear();
            cubit.individualHasChildren = false;

            cubit.buildNewIndividualTripCurrentStep = 0;
            customSnackBar(
              context: context,
              text: 'تم إنشاء رحلة بنجاح',
              color: ColorsManager.mainColor,
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
                    value: cubit.individualProgressValue(),
                  ),
                  SizedBox(height: 20.00.h),
                  buildStepContent(),
                  SizedBox(height: 20.00.h),
                  Row(
                    children: [
                      cubit.buildNewIndividualTripCurrentStep == 0
                          ? const SizedBox()
                          : CustomButton(
                              text: 'الرجوع',
                              onPressed: () {
                                setState(() {
                                  cubit.individualPreviousStep();
                                });
                              },
                            ),
                      const Spacer(),
                      cubit.buildNewIndividualTripCurrentStep != 4
                          ? CustomButton(
                              text: 'التالي',
                              onPressed: () {
                                // if true next step
                                if (cubit.checkIndividualTripValid()) {
                                  setState(() {
                                    cubit.individualNextStep();
                                    if (cubit
                                            .buildNewIndividualTripCurrentStep ==
                                        2) {
                                      cubit.individualFetchDistanceAndDuration(
                                          cubit
                                              .individualTripMeetingPointLatLng!,
                                          cubit
                                              .individualTripDestinationPointLatLng!);
                                    }
                                  });
                                }
                                // else show message
                                else {
                                  // meeting point handler
                                  if (cubit.buildNewIndividualTripCurrentStep ==
                                      0) {
                                    if (cubit.individualTripMeetingPointLatLng ==
                                            null ||
                                        cubit.individualTripMeetingPointAddress ==
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
                                  else if (cubit
                                          .buildNewIndividualTripCurrentStep ==
                                      1) {
                                    {
                                      if (cubit.individualTripDestinationPointLatLng ==
                                              null ||
                                          cubit.individualTripDestinationPointAddress ==
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
                                  else if (cubit
                                          .buildNewIndividualTripCurrentStep ==
                                      2) {
                                    {
                                      if (cubit.individualTripSelectedSquares
                                          .isEmpty) {
                                        customSnackBar(
                                          context: context,
                                          text: 'برجاء اختيار المقاعد',
                                          color: ColorsManager.red,
                                        );
                                      }
                                    }
                                  }
                                  // passengers data handler
                                  else if (cubit
                                          .buildNewIndividualTripCurrentStep ==
                                      3) {}
                                }
                              },
                            )
                          : state is LoadingGetInProgressTripsAppState
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : CustomButton(
                                  text: 'إرسال',
                                  onPressed: () {
                                    cubit.postTripIndividual();
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
