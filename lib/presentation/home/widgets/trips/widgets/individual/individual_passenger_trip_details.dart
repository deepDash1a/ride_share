import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_share/business_logic/trips/trips_cubit.dart';
import 'package:ride_share/core/shared/widgets/custom_drop_down.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/themes/fonts.dart';

class IndividualPassengerTripDetails extends StatefulWidget {
  const IndividualPassengerTripDetails({super.key});

  @override
  State<IndividualPassengerTripDetails> createState() =>
      _IndividualPassengerTripDetailsState();
}

class _IndividualPassengerTripDetailsState
    extends State<IndividualPassengerTripDetails> {
  @override
  Widget build(BuildContext context) {
    var cubit = context.read<TripsCubit>();

    return BlocConsumer<TripsCubit, TripsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Form(
          key: cubit.individualTripPassengerFormKey,
          child: Column(
            children: [
              const CustomText(text: 'أكمل بياناتك'),
              SizedBox(height: 20.h),
              CustomDropDownButton(
                hint: const CustomText(
                  text: 'اختر النوع',
                ),
                value: cubit.individualTripGenderSelectedValue,
                items: cubit.individualTripGenderList,
                validatorText: 'من فضلك اختر النوع',
                onChanged: (value) {
                  cubit.individualTripGenderSelectedValue = value;
                },
              ),
              SizedBox(height: 20.h),
              CustomDropDownButton(
                hint: const CustomText(
                  text: 'اختر الفئة العمرية',
                ),
                value: cubit.individualTripPassengerAgeSelectedValue,
                items: cubit.individualTripPassengerAgeList,
                validatorText: 'من فضلك اختر الفئة',
                onChanged: (value) {
                  cubit.individualTripPassengerAgeSelectedValue = value;
                },
              ),
              Row(
                children: [
                  Checkbox(
                    value: cubit.individualHasChildren,
                    onChanged: (value) {
                      cubit
                          .individualToggleHasChildren(); // عكس القيمة عند التغيير
                    },
                  ),
                  CustomText(
                    text: 'يوجد أطفال',
                    fontSize: 14.sp,
                    fontFamily: FontManager.regular,
                  ),
                ],
              ),
              if (cubit.individualHasChildren)
                CustomDropDownButton(
                  hint: const CustomText(
                    text: 'اختر فئة الاطفال العمرية',
                  ),
                  value: cubit.individualTripBabiesAgeSelectedValue,
                  items: cubit.individualTripBabiesAgeList,
                  validatorText: 'من فضلك اختر الفئة',
                  onChanged: (value) {
                    cubit.individualTripBabiesAgeSelectedValue = value;
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
