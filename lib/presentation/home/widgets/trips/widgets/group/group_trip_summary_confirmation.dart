import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_share/business_logic/trips/trips_cubit.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';

class GroupTripSummaryConfirmation extends StatefulWidget {
  const GroupTripSummaryConfirmation({super.key});

  @override
  State<GroupTripSummaryConfirmation> createState() =>
      _GroupTripSummaryConfirmationState();
}

class _GroupTripSummaryConfirmationState
    extends State<GroupTripSummaryConfirmation> {
  Widget buildDetailItem(String title, String value, IconData icon) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ListTile(
        leading: Icon(icon, color: ColorsManager.secondaryColor),
        title: CustomText(
          text: title,
          fontFamily: FontManager.bold,
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: CustomText(
            text: value,
            fontFamily: FontManager.regular,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<TripsCubit>();

    return BlocConsumer<TripsCubit, TripsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: [
            const CustomText(text: 'ملخص طلب الرحلة'),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity.w,
              child: Card(
                color: ColorsManager.mainColor,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: CustomText(
                    text: 'بيانات الرحلة',
                    color: ColorsManager.white,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
            if (cubit.groupId != null)
              Column(
                children: [
                  buildDetailItem(
                      'رقم المجموعة', cubit.groupId!, Icons.numbers),
                  SizedBox(height: 10.h),
                ],
              ),
            buildDetailItem(
              'نقطة الإلتقاء',
              cubit.groupTripMeetingPointAddress ?? 'غير متوفر',
              Icons.location_on,
            ),
            buildDetailItem(
              'نقطة الوصول',
              cubit.groupTripDestinationPointAddress ?? 'غير متوفر',
              Icons.flag,
            ),
            Row(
              children: [
                Expanded(
                  child: buildDetailItem(
                      'عدد المقاعد',
                      '${cubit.groupTripSeatsListSelectedValue}',
                      Icons.event_seat),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: buildDetailItem('تاريخ الرحلة',
                      cubit.groupTripSelectDate.text, Icons.date_range),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: buildDetailItem(
                    'موعد الرحلة من',
                    cubit.groupTripSelectTimeFrom.text,
                    Icons.access_time_rounded,
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: buildDetailItem(
                    'موعد الرحلة إلى',
                    cubit.groupTripSelectTimeTo.text,
                    Icons.access_time_rounded,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity.w,
              child: Card(
                color: ColorsManager.mainColor,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: CustomText(
                    text: 'بيانات الركاب',
                    color: ColorsManager.white,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: buildDetailItem(
                    'النوع',
                    cubit.groupTripGenderSelectedValue! == 'male'
                        ? 'ذكر'
                        : 'أنثى',
                    Icons.male,
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: buildDetailItem(
                    'الفئة العمُرية',
                    cubit.groupTripPassengerAgeSelectedValue!,
                    Icons.accessibility_new,
                  ),
                ),
              ],
            ),
            cubit.groupHasChildren
                ? buildDetailItem(
                    'الأطفال',
                    'تحتوي السيارة على أطفال \n ومتراوح الأعمار بين ${cubit.groupTripBabiesAgeSelectedValue} سنوات ',
                    Icons.child_care)
                : buildDetailItem(
                    'الأطفال', 'لا تحتوي السيارة على أطفال', Icons.no_accounts),
            Row(
              children: [
                Expanded(
                  child: buildDetailItem(
                    'المسافة المُقدرة (كيلومتر)',
                    '${(cubit.groupTripDistance ?? 0).toStringAsFixed(2)}',
                    Icons.social_distance,
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: buildDetailItem(
                    'الزمن المُقدر (دقيقة)',
                    '${(cubit.groupTripDuration ?? 0).toStringAsFixed(2)}',
                    Icons.timelapse_outlined,
                  ),
                ),
              ],
            ),
            buildDetailItem(
              'السعر المبدأي (بالجنيه)',
              (cubit.groupTripStartingPrice ?? 0).toStringAsFixed(2),
              Icons.monetization_on_outlined,
            ),
          ],
        );
      },
    );
  }
}
