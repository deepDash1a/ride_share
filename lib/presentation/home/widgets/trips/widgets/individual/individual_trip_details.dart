import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_share/business_logic/trips/trips_cubit.dart';
import 'package:ride_share/core/shared/functions/functions.dart';
import 'package:ride_share/core/shared/widgets/custom_drop_down.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';

class IndividualTripDetails extends StatefulWidget {
  const IndividualTripDetails({super.key});

  @override
  State<IndividualTripDetails> createState() => _IndividualTripDetailsState();
}

class _IndividualTripDetailsState extends State<IndividualTripDetails> {
  @override
  Widget build(BuildContext context) {
    var cubit = context.read<TripsCubit>();

    return BlocConsumer<TripsCubit, TripsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Form(
          key: cubit.individualTripTimeAndSeatsFormKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const CustomText(text: 'أكمل بيانات الرحلة'),
                  SizedBox(height: 20.h),
                  CustomDropDownButton(
                    hint: const CustomText(
                      text: 'اختر عدد المقاعد',
                    ),
                    value: cubit.individualTripSeatsListSelectedValue,
                    items: cubit.individualTripSeatsList,
                    validatorText: 'من فضلك اختر عدد المقاعد',
                    onChanged: (value) {
                      cubit.individualTripSeatsListSelectedValue = value;
                      cubit.individualUpdateSeatsCount(value);
                    },
                  ),
                  SizedBox(height: 5.h),
                  if (cubit.individualTripSeatsListSelectedValue != null)
                    SizedBox(
                      height: 375.h,
                      child: Padding(
                        padding: EdgeInsets.all(15.r),
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children: List.generate(4, (index) {
                            if (index == 1) {
                              return const SizedBox.shrink();
                            }

                            bool isSelected =
                            cubit.individualTripSelectedSquares.contains(index);

                            return GestureDetector(
                              onTap: () {
                                if (isSelected) {
                                  cubit.individualRemoveSeat(index);
                                } else if (cubit
                                    .individualTripSelectedSquares.length <
                                    (cubit.individualTripSeatsListSelectedValue ??
                                        0)) {
                                  cubit.individualAddSeat(index);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? ColorsManager.mainColor
                                      : ColorsManager.secondaryColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? ColorsManager.mainColor
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: CustomText(
                                    text: index == 0
                                        ? 'أمامي'
                                        : index == 2
                                        ? 'خلفي يمين'
                                        : 'خلفي يسار',
                                    color: ColorsManager.white,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  if (cubit.individualTripSeatsListSelectedValue == null)
                    SizedBox(height: 20.h),
                  const Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(text: 'اختر موعد الرحلة')),
                  TextFormField(
                    controller: cubit.individualTripSelectDate,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'من فضلك اختر التاريخ';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'اختر تاريخ البداية',
                      hintStyle: TextStyle(
                        fontSize: 16.00.sp,
                        fontFamily: FontManager.regular,
                      ),
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.date_range_outlined,
                        color: ColorsManager.secondaryColor,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      errorStyle: TextStyle(
                        fontSize: 12.00.sp,
                        color: ColorsManager.red,
                        fontFamily: FontManager.bold,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.00.h,
                        horizontal: 20.00.w,
                      ),
                    ),
                    readOnly: true,
                    onTap: () {
                      cubit.selectDate(context, cubit.individualTripSelectDate);
                      print(cubit.individualTripSelectDate.text);
                    },
                  ),
                  SizedBox(height: 20.h),
                  const Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(text: 'اختر وقت الرحلة من')),
                  TextFormField(
                    controller: cubit.individualTripSelectTimeFrom,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'من فضلك اختر الوقت';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'اختر وقت الرحلة من',
                      hintStyle: TextStyle(
                        fontSize: 16.00.sp,
                        fontFamily: FontManager.regular,
                      ),
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.date_range_outlined,
                        color: ColorsManager.secondaryColor,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      errorStyle: TextStyle(
                        fontSize: 12.00.sp,
                        color: ColorsManager.red,
                        fontFamily: FontManager.bold,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.00.h,
                        horizontal: 20.00.w,
                      ),
                    ),
                    readOnly: true,
                    onTap: () {
                      cubit.individualSelectTime(context, cubit.individualTripSelectTimeFrom);
                      print(cubit.individualTripSelectTimeFrom.text);
                    },
                  ),
                  SizedBox(height: 20.h),
                  const Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(text: 'اختر وقت الرحلة إلى')),
                  TextFormField(
                    controller: cubit.individualTripSelectTimeTo,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'من فضلك اختر الوقت';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'اختر وقت الرحلة إلى',
                      hintStyle: TextStyle(
                        fontSize: 16.00.sp,
                        fontFamily: FontManager.regular,
                      ),
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.date_range_outlined,
                        color: ColorsManager.secondaryColor,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      errorStyle: TextStyle(
                        fontSize: 12.00.sp,
                        color: ColorsManager.red,
                        fontFamily: FontManager.bold,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.00.h,
                        horizontal: 20.00.w,
                      ),
                    ),
                    readOnly: true,
                    onTap: () {
                      cubit.individualSelectTime(context, cubit.individualTripSelectTimeTo);
                      print(cubit.individualTripSelectTimeTo.text);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
