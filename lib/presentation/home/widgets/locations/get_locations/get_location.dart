import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_share/business_logic/home/home_cubit.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/data/models/home/location/location.dart';
import 'package:ride_share/presentation/home/widgets/locations/get_locations/view_all_maps_locations.dart';
import 'package:ride_share/presentation/home/widgets/locations/get_locations/view_map_location.dart';

class GetLocation extends StatelessWidget {
  const GetLocation({super.key});

  Widget locationItem(Locations locationModel, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewMapLocation(
              locationName: '${locationModel.locationName}',
              latitude: double.parse('${locationModel.latitude}'),
              longitude: double.parse('${locationModel.longitude}'),
            ),
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
                  Icon(Icons.person_pin, size: 24.w, color: Colors.blue),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomText(
                      text: 'اسم الموقع \n${locationModel.nickname}',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              const Divider(color: Colors.grey),
              CustomText(
                text: 'اسم الموقع',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 5.h),
              CustomText(
                text: '${locationModel.locationName}',
                fontSize: 14.sp,
                color: Colors.grey.shade800,
              ),
              SizedBox(height: 10.h),
              const Divider(color: Colors.grey),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 20.w, color: Colors.green),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: CustomText(
                      text:
                          'تاريخ الإضافة ${locationModel.createdAt!.split('T').first}',
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<HomeCubit>();
    return BlocConsumer<HomeCubit, HomeState>(
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
              text: 'عرض مواقعك',
              fontSize: 16.00.sp,
              fontFamily: FontManager.bold,
              color: ColorsManager.white,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () {
                    if (cubit.getLocationsModel != null &&
                        cubit.getLocationsModel!.body!.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewAllMapLocations(
                            locations: cubit.getLocationsModel!.body!,
                          ),
                        ),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.map,
                          color: ColorsManager.secondaryColor),
                      CustomText(
                        text: 'عرض جميع المواقع',
                        fontSize: 15.sp,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                cubit.getLocationsModel == null
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => locationItem(
                          cubit.getLocationsModel!.body![index],
                          context,
                        ),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10.h),
                        itemCount: cubit.getLocationsModel!.body!.length,
                      ),
                cubit.getLocationsModel == null
                    ? const Center(
                        child: CustomText(text: 'لا توجد أية مواقع لعرضها'),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}
