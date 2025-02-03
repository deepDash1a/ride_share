import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_share/business_logic/home/home_cubit.dart';
import 'package:ride_share/core/shared/functions/functions.dart';
import 'package:ride_share/core/shared/widgets/custom_button.dart';
import 'package:ride_share/core/shared/widgets/custom_drop_down.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/shared/widgets/custom_text_form_field.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/core/themes/images.dart';

class SetLocation extends StatefulWidget {
  const SetLocation({super.key});

  @override
  State<SetLocation> createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
  late Map<String, dynamic> jsonData;

  LatLng? mapLocation;
  GoogleMapController? mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    final String response =
        await rootBundle.loadString('assets/files/area.json');
    final data = await json.decode(response);

    setState(() {
      jsonData = data;
      context.read<HomeCubit>().locationGovernorates = List<String>.from(
        jsonData['governorates']?.map((governorate) => governorate['name']) ??
            [],
      );
    });
  }

  void updateDistricts(String governorate) {
    setState(() {
      context.read<HomeCubit>().locationDistricts =
          List<Map<String, dynamic>>.from(
        jsonData['governorates']?.firstWhere(
              (g) => g['name'] == governorate,
              orElse: () => {'districts': []},
            )['districts'] ??
            [],
      );
      context.read<HomeCubit>().selectedLocationDistrict = null;
      context.read<HomeCubit>().locationSubDistricts = [];
      context.read<HomeCubit>().selectedLocationSubDistrict = null;
    });
    updateMapLocation(
        governorate, context.read<HomeCubit>().selectedLocationDistrict ?? "");
  }

  void updateSubDistricts(String district) {
    final selectedDistrictData =
        context.read<HomeCubit>().locationDistricts.firstWhere(
              (d) => d['name'] == district,
              orElse: () => {'subDistricts': []},
            );

    setState(() {
      context.read<HomeCubit>().locationSubDistricts =
          List<String>.from(selectedDistrictData['sub_districts'] ?? []);
      context.read<HomeCubit>().selectedLocationSubDistrict = null;
    });
    updateMapLocation(
        context.read<HomeCubit>().selectedLocationGovernorate ?? "", district);
  }

  void updateMapLocation(String governorate, String district) {
    final selectedDistrictData =
        context.read<HomeCubit>().locationDistricts.firstWhere(
              (d) => d['name'] == district,
              orElse: () => {},
            );

    final latitude = selectedDistrictData['lat'] ??
        jsonData['governorates']
            .firstWhere((g) => g['name'] == governorate)['lat'];
    final longitude = selectedDistrictData['lng'] ??
        jsonData['governorates']
            .firstWhere((g) => g['name'] == governorate)['lng'];

    setState(() {
      mapLocation = LatLng(latitude, longitude);
      context.read<HomeCubit>().locationLatLng = mapLocation;
      markers.clear();
      markers.add(
        Marker(
          markerId: const MarkerId("selectedLocation"),
          position: context.read<HomeCubit>().locationLatLng!,
          infoWindow: InfoWindow(
              title: context.read<HomeCubit>().selectedLocationSubDistrict ??
                  district),
        ),
      );
    });

    if (mapController != null &&
        context.read<HomeCubit>().locationLatLng != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
            context.read<HomeCubit>().locationLatLng!, 12.0),
      );
    }
  }

  void onMapTapped(LatLng tappedPoint) async {
    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: const MarkerId("tappedLocation"),
          position: tappedPoint,
          infoWindow: const InfoWindow(title: "New Location"),
        ),
      );
      context.read<HomeCubit>().locationLatLng = tappedPoint;
    });

    List<Placemark> placemarks =
        await GeocodingPlatform.instance!.placemarkFromCoordinates(
      tappedPoint.latitude,
      tappedPoint.longitude,
    );

    if (placemarks.isNotEmpty) {
      final Placemark placemark = placemarks.first;
      context.read<HomeCubit>().locationAddress =
          '${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
      if (kDebugMode) {
        print(
            "Address: ${placemark.name}, ${placemark.locality}, ${placemark.country}, ");

        print(context.read<HomeCubit>().locationLatLng);
        print(context.read<HomeCubit>().locationAddress);
      }
      setState(() {
        markers.add(
          Marker(
            markerId: const MarkerId("tappedLocation"),
            position: tappedPoint,
            infoWindow: InfoWindow(
              title: placemark.name,
              snippet: '${placemark.locality}, ${placemark.country}',
            ),
          ),
        );
      });
    }

    if (mapController != null &&
        context.read<HomeCubit>().locationLatLng != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
            context.read<HomeCubit>().locationLatLng!, 12.0),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<HomeCubit>();
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is SuccessSaveLocationAppState) {
          customSnackBar(
            context: context,
            text: 'تم حفظ الموقع بنجاح في مواقعك المفضلة',
            color: ColorsManager.mainColor,
          );
          Navigator.pop(context);
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
              text: 'أضف موقعًا مميزًا لك',
              fontSize: 16.00.sp,
              fontFamily: FontManager.bold,
              color: ColorsManager.white,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: cubit.setLocationFormKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomDropDownButton(
                        hint: const CustomText(text: 'اختر المحافظة'),
                        value: cubit.selectedLocationGovernorate,
                        items: context
                            .read<HomeCubit>()
                            .locationGovernorates
                            .map((governorate) {
                          return DropdownMenuItem(
                            value: governorate,
                            child: CustomText(text: governorate),
                          );
                        }).toList(),
                        validatorText: 'من فضلك اختر المحافظة',
                        onChanged: (value) {
                          setState(() {
                            cubit.selectedLocationGovernorate = value!;
                            updateDistricts(value);
                          });
                        },
                      ),
                      SizedBox(height: 20.h),
                      CustomDropDownButton(
                        hint: const CustomText(text: 'اختر اللواء أو المركز'),
                        value: cubit.selectedLocationDistrict,
                        items: context
                            .read<HomeCubit>()
                            .locationDistricts
                            .map((district) {
                          return DropdownMenuItem(
                            value: district['name'],
                            child: CustomText(text: district['name']),
                          );
                        }).toList(),
                        validatorText: 'من فضلك اختر اللواء أو المركز',
                        onChanged: (value) {
                          setState(() {
                            cubit.selectedLocationDistrict = value!.toString();
                            updateSubDistricts(value.toString());
                          });
                        },
                      ),
                      SizedBox(height: 20.h),
                      CustomDropDownButton(
                        hint: const CustomText(text: 'اختر الناحية أو المنطقة'),
                        value: cubit.selectedLocationSubDistrict,
                        items: context
                            .read<HomeCubit>()
                            .locationSubDistricts
                            .map((subDistrict) {
                          return DropdownMenuItem(
                            value: subDistrict,
                            child: CustomText(text: subDistrict),
                          );
                        }).toList(),
                        validatorText: 'من فضلك اختر الناحية أو المنطقة',
                        onChanged: (value) {
                          setState(() {
                            cubit.selectedLocationSubDistrict = value!;
                            updateMapLocation(
                              cubit.selectedLocationGovernorate ?? "",
                              cubit.selectedLocationDistrict ?? "",
                            );
                          });
                        },
                      ),
                      SizedBox(height: 20.h),
                      cubit.locationLatLng == null
                          ? Container()
                          : SizedBox(
                              height: 500.h,
                              child: Container(
                                width: double.infinity.w,
                                height: 550.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10.0,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: GoogleMap(
                                    onMapCreated: _onMapCreated,
                                    initialCameraPosition: CameraPosition(
                                      target: cubit.locationLatLng!,
                                      zoom: 12.0,
                                    ),
                                    gestureRecognizers: {
                                      Factory<OneSequenceGestureRecognizer>(
                                        () => EagerGestureRecognizer(),
                                      ),
                                    },
                                    markers: markers,
                                    onTap: onMapTapped,
                                  ),
                                ),
                              ),
                            ),
                      cubit.locationAddress == null
                          ? Container()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 20.h),
                                const Align(
                                  alignment: Alignment.centerRight,
                                  child: CustomText(
                                    text: 'آخر موقع',
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                CustomText(
                                  text: '${cubit.locationAddress}',
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                      CustomTextFormField(
                        hintText: 'ضع اسمًا مميزًا',
                        prefixIcon: SvgPicture.asset(
                          ImagesManagers.locations,
                          height: 10.h,
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'من فضلك هذا الحقل مطلوب';
                          }
                          return null;
                        },
                        controller: cubit.locationNickNameController,
                        inputType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'المنزل',
                              onPressed: () {
                                cubit.locationNickNameController.text =
                                    'المنزل';
                              },
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: CustomButton(
                              text: 'العمل',
                              onPressed: () {
                                cubit.locationNickNameController.text = 'العمل';
                              },
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: CustomButton(
                              text: 'أخرى',
                              onPressed: () {
                                cubit.locationNickNameController.clear();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      state is LoadingSaveLocationAppState
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : CustomButton(
                              text: 'حفظ الموقع',
                              onPressed: () {
                                if (cubit.setLocationFormKey.currentState!
                                    .validate()) {
                                  cubit.saveLocation();
                                }
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
