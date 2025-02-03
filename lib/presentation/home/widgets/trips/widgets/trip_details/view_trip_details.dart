import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_share/business_logic/trips/trips_cubit.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/data/models/home/trip/trip_model.dart';

class TripDetailsScreen extends StatelessWidget {
  final TripModel tripModel;

  const TripDetailsScreen({super.key, required this.tripModel});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripsCubit, TripsState>(
      listener: (context, state) {},
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
              text: 'عرض تفاصيل الرحلة',
              fontSize: 16.00.sp,
              fontFamily: FontManager.bold,
              color: ColorsManager.white,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.w),
            child: ListView(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem('رقم الرحلة', '${tripModel.id}',
                          Icons.confirmation_number),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _buildDetailItem('عدد الركاب',
                          '${tripModel.numPassengers}', Icons.people),
                    ),
                  ],
                ),
                _buildDetailItem(
                    'التاريخ',
                    tripModel.tripDate?.split('T').first ?? 'غير متوفر',
                    Icons.date_range),
                _buildDetailItem('نقطة الإلتقاء',
                    tripModel.pickupPoint ?? 'غير متوفر', Icons.location_on),
                if (tripModel.startTime != null)
                  _buildDetailItem('وقت الإلتقاء', '${tripModel.startTime}',
                      Icons.access_time),
                if (tripModel.destination != null)
                  _buildDetailItem(
                      'وجهة الوصول', tripModel.destination!, Icons.flag),
                if (tripModel.endTimeFrom != null &&
                    tripModel.endTimeTo != null)
                  _buildDetailItem(
                      'وقت الوصول',
                      '${tripModel.endTimeFrom} - ${tripModel.endTimeTo}',
                      Icons.access_time_filled),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                          'المسافة المتوقعة',
                          '${tripModel.expectedDistance?.toStringAsFixed(2)} كم',
                          Icons.route),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _buildDetailItem(
                          'السعر النهائي',
                          '${tripModel.finalPrice ?? tripModel.initialPrice} EGP',
                          Icons.price_change),
                    ),
                  ],
                ),
                _buildDetailItem(
                    'حالة الرحلة',
                    tripModel.status! == 'pending'
                        ? 'الرحلة قيد المراجعة'
                        : tripModel.status! == 'approved'
                            ? 'الرحلة مقبولة'
                            : tripModel.status! == 'in-progress'
                                ? 'الرحلة قيد التنفيذ'
                                : tripModel.status! == 'completed'
                                    ? 'الرحلة مكتملة'
                                    : tripModel.status! == 'rejected'
                                        ? 'الرحلة مرفوضة'
                                        : tripModel.status! == 'canceled'
                                            ? 'الرحلة مغلقة'
                                            : 'لم يتم تحديد حالة الرحلة' ??
                                                'غير متوفر',
                    Icons.info),
                _buildDetailItem(
                    'النوع', tripModel.gender ?? 'غير متوفر', Icons.person),
                _buildDetailItem(
                    'الفئة العمرية', tripModel.age ?? 'غير متوفر', Icons.cake),
                _buildDetailItem(
                    'الأطفال', '${tripModel.babies}', Icons.child_care),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String title, String value, IconData icon) {
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
}
