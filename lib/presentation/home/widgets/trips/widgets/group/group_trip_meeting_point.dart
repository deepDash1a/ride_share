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
import 'package:http/http.dart' as http;
import 'package:ride_share/business_logic/home/home_cubit.dart';
import 'package:ride_share/business_logic/trips/trips_cubit.dart';
import 'package:ride_share/core/shared/functions/functions.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences_keys.dart';
import 'package:ride_share/core/shared/widgets/custom_drop_down.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/shared/widgets/custom_text_form_field.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/images.dart';
import 'package:share_plus/share_plus.dart';

class GroupTripMeetingPoint extends StatefulWidget {
  const GroupTripMeetingPoint({super.key});

  @override
  State<GroupTripMeetingPoint> createState() => _GroupTripMeetingPointState();
}

class _GroupTripMeetingPointState extends State<GroupTripMeetingPoint> {
  late Map<String, dynamic> jsonData;

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
      context.read<TripsCubit>().groupTripMeetingPointLocationGovernorates =
          List<String>.from(
        jsonData['governorates']?.map((governorate) => governorate['name']) ??
            [],
      );
    });
  }

  void updateDistricts(String governorate) {
    setState(() {
      context.read<TripsCubit>().groupTripMeetingPointLocationDistricts =
          List<Map<String, dynamic>>.from(
        jsonData['governorates']?.firstWhere(
              (g) => g['name'] == governorate,
              orElse: () => {'districts': []},
            )['districts'] ??
            [],
      );
      context.read<TripsCubit>().groupTripMeetingPointSelectedLocationDistrict =
          null;
      context.read<TripsCubit>().groupTripMeetingPointLocationSubDistricts = [];
      context
          .read<TripsCubit>()
          .groupTripMeetingPointSelectedLocationSubDistrict = null;
    });
  }

  void updateSubDistricts(String district) {
    final selectedDistrictData = context
        .read<TripsCubit>()
        .groupTripMeetingPointLocationDistricts
        .firstWhere(
          (d) => d['name'] == district,
          orElse: () => {'subDistricts': []},
        );

    setState(() {
      context.read<TripsCubit>().groupTripMeetingPointLocationSubDistricts =
          List<String>.from(selectedDistrictData['sub_districts'] ?? []);
      context
          .read<TripsCubit>()
          .groupTripMeetingPointSelectedLocationSubDistrict = null;
    });
  }

  Future<void> showMapForSubDistrict() async {
    final governmentName = context
        .read<TripsCubit>()
        .groupTripMeetingPointSelectedLocationGovernorate;
    final districtName = context
        .read<TripsCubit>()
        .groupTripMeetingPointSelectedLocationDistrict;
    final subDistrictName = context
        .read<TripsCubit>()
        .groupTripMeetingPointSelectedLocationSubDistrict;

    if (subDistrictName != null) {
      const apiKey = 'AIzaSyBtpz1PYwlJoXX_OC4Mpi9-h4mDzyPZGvM';
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$governmentName,$districtName,$subDistrictName&key=$apiKey',
      );

      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['results'] != null && data['results'].isNotEmpty) {
            final location = data['results'][0]['geometry']['location'];

            final latitude = location['lat'] ?? 0.0;
            final longitude = location['lng'] ?? 0.0;

            setState(() {
              context.read<TripsCubit>().groupTripMeetingPointMapLocation =
                  LatLng(latitude, longitude);
              context.read<TripsCubit>().groupTripMeetingPointLatLng =
                  context.read<TripsCubit>().groupTripMeetingPointMapLocation;
              context.read<TripsCubit>().groupTripMeetingPointMarkers.clear();
              context.read<TripsCubit>().groupTripMeetingPointMarkers.add(
                    Marker(
                      markerId: MarkerId(subDistrictName),
                      position: context.read<HomeCubit>().locationLatLng!,
                      infoWindow: InfoWindow(title: subDistrictName),
                    ),
                  );
            });

            context
                .read<TripsCubit>()
                .groupTripMeetingPointMapController
                ?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                      context.read<TripsCubit>().groupTripMeetingPointLatLng!,
                      16.0),
                );
          } else {
            customSnackBar(
              context: context,
              text: 'لم يتم العثور على الموقع. حاول مجددًا.',
              color: Colors.red,
            );
          }
        } else {
          customSnackBar(
            context: context,
            text: 'حدث خطأ أثناء البحث عن الموقع.',
            color: Colors.red,
          );
        }
      } catch (e) {
        customSnackBar(
          context: context,
          text: 'فشل الاتصال بالخادم. اختر المنطقة مرة أخرى.',
          color: Colors.red,
        );
      }
    }
  }

  void onMapTapped(LatLng tappedPoint) async {
    setState(() {
      context.read<TripsCubit>().groupTripMeetingPointMarkers.clear();
      context.read<TripsCubit>().groupTripMeetingPointMarkers.add(
            Marker(
              markerId: const MarkerId("tappedLocation"),
              position: tappedPoint,
              infoWindow: const InfoWindow(title: "New Location"),
            ),
          );
      context.read<TripsCubit>().groupTripMeetingPointLatLng = tappedPoint;
    });

    try {
      List<Placemark> placemarks = await GeocodingPlatform.instance!
          .placemarkFromCoordinates(
              tappedPoint.latitude, tappedPoint.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = '${place.street}, ${place.locality}, ${place.country}';

        context.read<TripsCubit>().groupTripMeetingPointAddress = address;
        print("Address: $address");

        setState(() {
          context.read<TripsCubit>().groupTripMeetingPointMarkers.clear();
          context.read<TripsCubit>().groupTripMeetingPointMarkers.add(
                Marker(
                  markerId: const MarkerId("tappedLocation"),
                  position: tappedPoint,
                  infoWindow:
                      InfoWindow(title: "New Location", snippet: address),
                ),
              );
        });
      } else {
        print("No address found for this location");
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      context.read<TripsCubit>().groupTripMeetingPointMapController =
          controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<TripsCubit>();

    return BlocConsumer<TripsCubit, TripsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Form(
          key: cubit.groupTripMeetingPointFormKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const CustomText(text: 'أدخل بيانات نقطة الإلتقاء'),
                  SizedBox(height: 20.h),
                  if (SharedPreferencesService.getData(
                          key: SharedPreferencesKeys.joinOrCreate) ==
                      'create') ...{
                    if (context.read<TripsCubit>().groupId != null) ...{
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                            text: 'كود المجموعة',
                            color: ColorsManager.secondaryColor,
                          ),
                          CustomText(
                            text: '${context.read<TripsCubit>().groupId}',
                            color: ColorsManager.secondaryColor,
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.copy,
                                    color: ColorsManager.mainColor),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                      text: context
                                          .read<TripsCubit>()
                                          .groupId
                                          .toString()));
                                  customSnackBar(
                                    context: context,
                                    text: 'تم نسخ كود المجموعة إلى الحافظة',
                                    color: ColorsManager.mainColor,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.share,
                                    color: ColorsManager.mainColor),
                                onPressed: () async {
                                  final groupId = context
                                      .read<TripsCubit>()
                                      .groupId
                                      .toString();
                                  await Share.share('كود المجموعة: $groupId'
                                      '\n يمكنك تحميل التطبيق من خلال https://www.google.com.eg/');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                    }
                  },
                  CustomTextFormField(
                    hintText: 'أدخل كود المجموعة وانضم الآن',
                    prefixIcon: SvgPicture.asset(
                      ImagesManagers.join,
                      height: 10.h,
                    ),
                    controller: cubit.groupTripMeetingPointJoinController,
                    inputType: TextInputType.name,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'من فضلك أدخل كود المجموعة';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomDropDownButton(
                    hint: const CustomText(text: 'اختر المحافظة'),
                    value:
                        cubit.groupTripMeetingPointSelectedLocationGovernorate,
                    items: cubit.groupTripMeetingPointLocationGovernorates
                        .map((governorate) {
                      return DropdownMenuItem(
                        value: governorate,
                        child: CustomText(text: governorate),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        cubit.groupTripMeetingPointSelectedLocationGovernorate =
                            value!;
                        updateDistricts(value);
                      });
                    },
                    validatorText: 'من فضلك أدخل المحافظة',
                  ),
                  SizedBox(height: 20.h),
                  CustomDropDownButton(
                    hint: const CustomText(text: 'اختر اللواء أو المركز'),
                    value: cubit.groupTripMeetingPointSelectedLocationDistrict,
                    items: cubit.groupTripMeetingPointLocationDistricts
                        .map((district) {
                      return DropdownMenuItem(
                        value: district['name'],
                        child: CustomText(text: district['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        cubit.groupTripMeetingPointSelectedLocationDistrict =
                            value!.toString();
                        updateSubDistricts(value.toString());
                      });
                    },
                    validatorText: 'من فضلك أدخل اللواء أو المركز',
                  ),
                  SizedBox(height: 20.h),
                  CustomDropDownButton(
                    hint: const CustomText(text: 'اختر الناحية أو المنطقة'),
                    validatorText: 'من فضلك أدخل الناحية او المنطقة',
                    value:
                        cubit.groupTripMeetingPointSelectedLocationSubDistrict,
                    items: cubit.groupTripMeetingPointLocationSubDistricts
                        .map((subDistrict) {
                      return DropdownMenuItem(
                        value: subDistrict,
                        child: CustomText(text: subDistrict),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        cubit.groupTripMeetingPointSelectedLocationSubDistrict =
                            value!;
                        showMapForSubDistrict();
                      });
                    },
                  ),
                  SizedBox(height: 20.h),
                  cubit.groupTripMeetingPointLatLng == null
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
                                  target: cubit.groupTripMeetingPointLatLng!,
                                  zoom: 14.0,
                                ),
                                markers: cubit.groupTripMeetingPointMarkers,
                                onTap: onMapTapped,
                                gestureRecognizers: {
                                  Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer(),
                                  ),
                                },
                              ),
                            ),
                          ),
                        ),
                  if (cubit.groupTripMeetingPointAddress != null)
                    Column(
                      children: [
                        SizedBox(height: 20.h),
                        CustomText(text: cubit.groupTripMeetingPointAddress!),
                      ],
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
