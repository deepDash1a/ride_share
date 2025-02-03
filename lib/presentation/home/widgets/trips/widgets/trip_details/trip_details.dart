import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_share/business_logic/trips/trips_cubit.dart';
import 'package:ride_share/core/shared/widgets/custom_button.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/core/themes/images.dart';
import 'package:ride_share/data/models/home/trip/trip_model.dart';
import 'package:ride_share/presentation/home/widgets/trips/widgets/trip_details/view_trip_details.dart';

class TripDetails extends StatelessWidget {
  const TripDetails({super.key});

  Widget tripItem(TripModel tripModel, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TripDetailsScreen(tripModel: tripModel),
          ),
        );
      },
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildDetailBadge('ID', '${tripModel.id}'),
                  SizedBox(
                    width: 10.w,
                  ),
                  _buildDetailBadge('السعر',
                      '${tripModel.finalPrice ?? tripModel.initialPrice} EGP'),
                ],
              ),
              SizedBox(height: 10.h),
              if (tripModel.pickupPoint != null)
                _buildDetailRow(
                    'نقطة الالتقاء', tripModel.pickupPoint!, Icons.location_on),
              if (tripModel.destination != null)
                _buildDetailRow('الوجهة', tripModel.destination!, Icons.flag),
              if (tripModel.status != null)
                _buildDetailRow(
                    'الحالة',
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
                                            : 'لم يتم تحديد حالة الرحلة',
                    Icons.info),
              if (tripModel.tripDate != null)
                _buildDetailRow(
                    'تاريخ الرحلة',
                    tripModel.tripDate!.toString().split('T').first,
                    Icons.date_range),
              SizedBox(height: 10.h),
              const Center(
                child: CustomText(
                  text: 'اضغط لعرض التفاصيل',
                  color: ColorsManager.secondaryColor,
                  fontFamily: FontManager.regular,
                ),
              ),
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomButton(
                  text: 'إلغاء الرحلة',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const CustomText(
                            text: 'تأكيد الإلغاء',
                            fontSize: 16.0,
                            fontFamily: FontManager.bold,
                          ),
                          content: const CustomText(
                            text:
                                'هل أنت متأكد أنك تريد إلغاء هذه الرحلة؟ لا يمكن التراجع عن هذا الإجراء.',
                            fontSize: 14.0,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const CustomText(
                                text: 'تراجع',
                                color: ColorsManager.secondaryColor,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context
                                    .read<TripsCubit>()
                                    .updateTripCanceled(id: tripModel.id!);
                                Navigator.pop(
                                  context,
                                );
                              },
                              child: const CustomText(
                                text: 'إلغاء الرحلة',
                                color: Colors.red,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: ColorsManager.mainColor),
              SizedBox(width: 10.w),
              CustomText(
                text: title,
              ),
            ],
          ),
          CustomText(
            text: value,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailBadge(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: ColorsManager.mainColor,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: CustomText(
        text: value,
        color: ColorsManager.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<TripsCubit>();
    int currentIndex = 0;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ColorsManager.white,
            size: 20.0,
          ),
        ),
        titleSpacing: 0.0,
        title: CustomText(
          text: 'عرض كل الرحلات',
          fontSize: 16.0.sp,
          fontFamily: FontManager.bold,
          color: ColorsManager.white,
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onSelected: (value) {
              if (value == 'pending') {
                currentIndex = 1;
                cubit.getPendingTrips();
              } else if (value == 'approved') {
                currentIndex = 2;
                cubit.getApprovedTrips();
              } else if (value == 'in_progress') {
                currentIndex = 3;
                cubit.getInProgressTrips();
              } else if (value == 'completed') {
                currentIndex = 4;
                cubit.getCompletedTrips();
              } else if (value == 'rejected') {
                currentIndex = 5;
                cubit.getRejectedTrips();
              } else if (value == 'canceled') {
                currentIndex = 6;
                cubit.getCanceledTrips();
              }

              cubit.refreshState();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'pending',
                child: Row(
                  children: [
                    SvgPicture.asset(
                      ImagesManagers.pending,
                      height: 25.h,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    CustomText(
                      text: 'الرحلات قيد المراجعة',
                      fontFamily: FontManager.regular,
                      fontSize: 14.sp,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'approved',
                child: Row(
                  children: [
                    SvgPicture.asset(
                      ImagesManagers.approved,
                      height: 25.h,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    CustomText(
                      text: 'الرحلات المقبولة',
                      fontFamily: FontManager.regular,
                      fontSize: 14.sp,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'in_progress',
                child: Row(
                  children: [
                    SvgPicture.asset(
                      ImagesManagers.inProgress,
                      height: 25.h,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    CustomText(
                      text: 'الرحلات قيد التنفيذ',
                      fontFamily: FontManager.regular,
                      fontSize: 14.sp,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'completed',
                child: Row(
                  children: [
                    SvgPicture.asset(
                      ImagesManagers.completed,
                      height: 25.h,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    CustomText(
                      text: 'الرحلات المكتملة',
                      fontFamily: FontManager.regular,
                      fontSize: 14.sp,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'rejected',
                child: Row(
                  children: [
                    SvgPicture.asset(
                      ImagesManagers.rejected,
                      height: 25.h,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    CustomText(
                      text: 'الرحلات المرفوضة',
                      fontFamily: FontManager.regular,
                      fontSize: 14.sp,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'canceled',
                child: Row(
                  children: [
                    SvgPicture.asset(
                      ImagesManagers.canceled,
                      height: 25.h,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    CustomText(
                      text: 'الرحلات المغلقة',
                      fontFamily: FontManager.regular,
                      fontSize: 14.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<TripsCubit, TripsState>(
        listener: (context, state) {
          if (state is SuccessUpdateCanceledTripAppState) {
            cubit.getAllTrips();
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Image.asset(
                ImagesManagers.wallPaper,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              Center(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: BlocConsumer<TripsCubit, TripsState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            if (currentIndex == 0) ...{
                              const Align(
                                alignment: Alignment.centerRight,
                                child: CustomText(
                                  text: 'جميع الرحلات',
                                ),
                              ),
                              SizedBox(height: 20.h),
                              cubit.getAllTripModel == null
                                  ? Center(
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            ImagesManagers.noData,
                                            height: 200.h,
                                          ),
                                          const CustomText(
                                            text:
                                                'لا توجد رحلات في الوقت الحالي لعرضها',
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.separated(
                                      itemBuilder: (context, index) => tripItem(
                                          cubit.getAllTripModel!.body![index],
                                          context),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        height: 10.h,
                                      ),
                                      itemCount:
                                          cubit.getAllTripModel!.body!.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                    )
                            },
                            if (currentIndex == 1) ...{
                              const Align(
                                alignment: Alignment.centerRight,
                                child: CustomText(
                                  text: 'الرحلات قيد المراجعة',
                                ),
                              ),
                              SizedBox(height: 20.h),
                              cubit.pendingTripsModel == null ||
                                      cubit.pendingTripsModel!.body!.isEmpty
                                  ? Center(
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            ImagesManagers.noData,
                                            height: 200.h,
                                          ),
                                          const CustomText(
                                            text:
                                                'لا توجد رحلات في الوقت الحالي لعرضها',
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.separated(
                                      itemBuilder: (context, index) => tripItem(
                                          cubit.pendingTripsModel!.body![index],
                                          context),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(height: 10.h),
                                      itemCount:
                                          cubit.pendingTripsModel!.body!.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                    )
                            },
                            if (currentIndex == 2) ...{
                              const Align(
                                alignment: Alignment.centerRight,
                                child: CustomText(
                                  text: 'الرحلات المقبولة',
                                ),
                              ),
                              SizedBox(height: 20.h),
                              cubit.approvedTripsModel == null ||
                                      cubit.approvedTripsModel!.body!.isEmpty
                                  ? Center(
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            ImagesManagers.noData,
                                            height: 200.h,
                                          ),
                                          const CustomText(
                                            text:
                                                'لا توجد رحلات في الوقت الحالي لعرضها',
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.separated(
                                      itemBuilder: (context, index) => tripItem(
                                          cubit
                                              .approvedTripsModel!.body![index],
                                          context),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(height: 10.h),
                                      itemCount: cubit
                                          .approvedTripsModel!.body!.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                    )
                            },
                            if (currentIndex == 3) ...{
                              const Align(
                                alignment: Alignment.centerRight,
                                child: CustomText(
                                  text: 'الرحلات قيد التنفيذ',
                                ),
                              ),
                              SizedBox(height: 20.h),
                              cubit.inProgressTripsModel == null ||
                                      cubit.inProgressTripsModel!.body!.isEmpty
                                  ? Center(
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            ImagesManagers.noData,
                                            height: 200.h,
                                          ),
                                          const CustomText(
                                            text:
                                                'لا توجد رحلات في الوقت الحالي لعرضها',
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.separated(
                                      itemBuilder: (context, index) => tripItem(
                                          cubit.inProgressTripsModel!
                                              .body![index],
                                          context),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(height: 10.h),
                                      itemCount: cubit
                                          .inProgressTripsModel!.body!.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                    )
                            },
                            if (currentIndex == 4) ...{
                              const Align(
                                alignment: Alignment.centerRight,
                                child: CustomText(
                                  text: 'الرحلات المكتملة',
                                ),
                              ),
                              SizedBox(height: 20.h),
                              cubit.completedTripsModel == null ||
                                      cubit.completedTripsModel!.body!.isEmpty
                                  ? Center(
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            ImagesManagers.noData,
                                            height: 200.h,
                                          ),
                                          const CustomText(
                                            text:
                                                'لا توجد رحلات في الوقت الحالي لعرضها',
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.separated(
                                      itemBuilder: (context, index) => tripItem(
                                          cubit.completedTripsModel!
                                              .body![index],
                                          context),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(height: 10.h),
                                      itemCount: cubit
                                          .completedTripsModel!.body!.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                    )
                            },
                            if (currentIndex == 5) ...{
                              const Align(
                                alignment: Alignment.centerRight,
                                child: CustomText(
                                  text: 'الرحلات المرفوضة',
                                ),
                              ),
                              SizedBox(height: 20.h),
                              cubit.rejectedTripsModel == null ||
                                      cubit.rejectedTripsModel!.body!.isEmpty
                                  ? Center(
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            ImagesManagers.noData,
                                            height: 200.h,
                                          ),
                                          const CustomText(
                                            text:
                                                'لا توجد رحلات في الوقت الحالي لعرضها',
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.separated(
                                      itemBuilder: (context, index) => tripItem(
                                          cubit
                                              .rejectedTripsModel!.body![index],
                                          context),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(height: 10.h),
                                      itemCount: cubit
                                          .rejectedTripsModel!.body!.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                    )
                            },
                            if (currentIndex == 6) ...{
                              const Align(
                                alignment: Alignment.centerRight,
                                child: CustomText(
                                  text: 'الرحلات المغلقة',
                                ),
                              ),
                              SizedBox(height: 20.h),
                              cubit.canceledTripsModel == null ||
                                      cubit.canceledTripsModel!.body!.isEmpty
                                  ? Center(
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            ImagesManagers.noData,
                                            height: 200.h,
                                          ),
                                          const CustomText(
                                            text:
                                                'لا توجد رحلات في الوقت الحالي لعرضها',
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.separated(
                                      itemBuilder: (context, index) => tripItem(
                                          cubit
                                              .canceledTripsModel!.body![index],
                                          context),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(height: 10.h),
                                      itemCount: cubit
                                          .canceledTripsModel!.body!.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                    )
                            },
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
