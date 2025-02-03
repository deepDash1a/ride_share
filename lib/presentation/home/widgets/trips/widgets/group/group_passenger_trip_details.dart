import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_share/business_logic/trips/trips_cubit.dart';
import 'package:ride_share/core/shared/widgets/custom_drop_down.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/themes/fonts.dart';

class GroupPassengerTripDetails extends StatefulWidget {
  const GroupPassengerTripDetails({super.key});

  @override
  State<GroupPassengerTripDetails> createState() =>
      _GroupPassengerTripDetailsState();
}

class _GroupPassengerTripDetailsState extends State<GroupPassengerTripDetails> {
  @override
  Widget build(BuildContext context) {
    var cubit = context.read<TripsCubit>();

    return BlocConsumer<TripsCubit, TripsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Form(
          key: cubit.groupTripPassengerFormKey,
          child: Column(
            children: [
              const CustomText(text: 'أكمل بياناتك'),
              SizedBox(height: 20.h),
              CustomDropDownButton(
                hint: const CustomText(
                  text: 'اختر النوع',
                ),
                value: cubit.groupTripGenderSelectedValue,
                items: cubit.groupTripGenderList,
                validatorText: 'من فضلك اختر النوع',
                onChanged: (value) {
                  cubit.groupTripGenderSelectedValue = value;
                },
              ),
              SizedBox(height: 20.h),
              CustomDropDownButton(
                hint: const CustomText(
                  text: 'اختر الفئة العمرية',
                ),
                value: cubit.groupTripPassengerAgeSelectedValue,
                items: cubit.groupTripPassengerAgeList,
                validatorText: 'من فضلك اختر الفئة',
                onChanged: (value) {
                  cubit.groupTripPassengerAgeSelectedValue = value;
                },
              ),
              Row(
                children: [
                  Checkbox(
                    value: cubit.groupHasChildren,
                    onChanged: (value) {
                      cubit.groupToggleHasChildren(); // عكس القيمة عند التغيير
                    },
                  ),
                  CustomText(
                    text: 'يوجد أطفال',
                    fontSize: 14.sp,
                    fontFamily: FontManager.regular,
                  ),
                ],
              ),
              if (cubit.groupHasChildren)
                CustomDropDownButton(
                  hint: const CustomText(
                    text: 'اختر فئة الاطفال العمرية',
                  ),
                  value: cubit.groupTripBabiesAgeSelectedValue,
                  items: cubit.groupTripBabiesAgeList,
                  validatorText: 'من فضلك اختر الفئة',
                  onChanged: (value) {
                    cubit.groupTripBabiesAgeSelectedValue = value;
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
