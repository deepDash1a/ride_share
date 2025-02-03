import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ride_share/business_logic/home/home_cubit.dart';
import 'package:ride_share/business_logic/trips/trips_cubit.dart';
import 'package:ride_share/core/shared/functions/functions.dart';
import 'package:ride_share/core/shared/widgets/custom_drop_down.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';

class IndividualTripDestinationPoint extends StatefulWidget {
  const IndividualTripDestinationPoint({super.key});

  @override
  State<IndividualTripDestinationPoint> createState() =>
      _IndividualTripDestinationPointState();
}

class _IndividualTripDestinationPointState
    extends State<IndividualTripDestinationPoint> {
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
      context.read<TripsCubit>().individualTripDestinationPointLocationGovernorates =
          List<String>.from(
        jsonData['governorates']?.map((governorate) => governorate['name']) ??
            [],
      );
    });
  }

  void updateDistricts(String governorate) {
    setState(() {
      context.read<TripsCubit>().individualTripDestinationPointLocationDistricts =
          List<Map<String, dynamic>>.from(
        jsonData['governorates']?.firstWhere(
              (g) => g['name'] == governorate,
              orElse: () => {'districts': []},
            )['districts'] ??
            [],
      );
      context
          .read<TripsCubit>()
          .individualTripDestinationPointSelectedLocationDistrict = null;
      context.read<TripsCubit>().individualTripDestinationPointLocationSubDistricts =
          [];
      context
          .read<TripsCubit>()
          .individualTripDestinationPointSelectedLocationSubDistrict = null;
    });
  }

  void updateSubDistricts(String district) {
    final selectedDistrictData = context
        .read<TripsCubit>()
        .individualTripDestinationPointLocationDistricts
        .firstWhere(
          (d) => d['name'] == district,
          orElse: () => {'subDistricts': []},
        );

    setState(() {
      context.read<TripsCubit>().individualTripDestinationPointLocationSubDistricts =
          List<String>.from(selectedDistrictData['sub_districts'] ?? []);
      context
          .read<TripsCubit>()
          .individualTripDestinationPointSelectedLocationSubDistrict = null;
    });
  }

  Future<void> showMapForSubDistrict() async {
    final governmentName = context
        .read<TripsCubit>()
        .individualTripDestinationPointSelectedLocationGovernorate;
    final districtName = context
        .read<TripsCubit>()
        .individualTripDestinationPointSelectedLocationDistrict;
    final subDistrictName = context
        .read<TripsCubit>()
        .individualTripDestinationPointSelectedLocationSubDistrict;

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
              context.read<TripsCubit>().individualTripDestinationPointMapLocation =
                  LatLng(latitude, longitude);
              context.read<TripsCubit>().individualTripDestinationPointLatLng =
                  context
                      .read<TripsCubit>()
                      .individualTripDestinationPointMapLocation;
              context
                  .read<TripsCubit>()
                  .individualTripDestinationPointMarkers
                  .clear();
              context.read<TripsCubit>().individualTripDestinationPointMarkers.add(
                    Marker(
                      markerId: MarkerId(subDistrictName),
                      position: context.read<HomeCubit>().locationLatLng!,
                      infoWindow: InfoWindow(title: subDistrictName),
                    ),
                  );
            });

            context
                .read<TripsCubit>()
                .individualTripDestinationPointMapController
                ?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                      context
                          .read<TripsCubit>()
                          .individualTripDestinationPointLatLng!,
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
      context.read<TripsCubit>().individualTripDestinationPointMarkers.clear();
      context.read<TripsCubit>().individualTripDestinationPointMarkers.add(
            Marker(
              markerId: const MarkerId("tappedLocation"),
              position: tappedPoint,
              infoWindow: const InfoWindow(title: "New Location"),
            ),
          );
      context.read<TripsCubit>().individualTripDestinationPointLatLng = tappedPoint;
    });

    try {
      List<Placemark> placemarks = await GeocodingPlatform.instance!
          .placemarkFromCoordinates(
              tappedPoint.latitude, tappedPoint.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = '${place.street}, ${place.locality}, ${place.country}';

        context.read<TripsCubit>().individualTripDestinationPointAddress = address;
        print("Address: $address");

        setState(() {
          context.read<TripsCubit>().individualTripDestinationPointMarkers.clear();
          context.read<TripsCubit>().individualTripDestinationPointMarkers.add(
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
      context.read<TripsCubit>().individualTripDestinationPointMapController =
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
          key: cubit.individualTripDestinationPointFormKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const CustomText(text: 'أدخل بيانات نقطة الوصول'),
                  SizedBox(height: 20.h),
                  CustomDropDownButton(
                    hint: const CustomText(text: 'اختر المحافظة'),
                    value: cubit
                        .individualTripDestinationPointSelectedLocationGovernorate,
                    items: cubit.individualTripDestinationPointLocationGovernorates
                        .map((governorate) {
                      return DropdownMenuItem(
                        value: governorate,
                        child: CustomText(text: governorate),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        cubit.individualTripDestinationPointSelectedLocationGovernorate =
                            value!;
                        updateDistricts(value);
                      });
                    },
                    validatorText: 'من فضلك أدخل المحافظة',
                  ),
                  SizedBox(height: 20.h),
                  CustomDropDownButton(
                    hint: const CustomText(text: 'اختر اللواء أو المركز'),
                    value:
                        cubit.individualTripDestinationPointSelectedLocationDistrict,
                    items: cubit.individualTripDestinationPointLocationDistricts
                        .map((district) {
                      return DropdownMenuItem(
                        value: district['name'],
                        child: CustomText(text: district['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        cubit.individualTripDestinationPointSelectedLocationDistrict =
                            value!.toString();
                        updateSubDistricts(value.toString());
                      });
                    },
                    validatorText: 'من فضلك أدخل اللواء أو المركز',
                  ),
                  SizedBox(height: 20.h),
                  CustomDropDownButton(
                    hint: const CustomText(text: 'اختر الناحية أو المنطقة'),
                    value: cubit
                        .individualTripDestinationPointSelectedLocationSubDistrict,
                    items: cubit.individualTripDestinationPointLocationSubDistricts
                        .map((subDistrict) {
                      return DropdownMenuItem(
                        value: subDistrict,
                        child: CustomText(text: subDistrict),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        cubit.individualTripDestinationPointSelectedLocationSubDistrict =
                            value!;
                        showMapForSubDistrict();
                      });
                    },
                    validatorText: 'من فضلك أدخل الناحية او المنطقة',
                  ),
                  SizedBox(height: 20.h),
                  cubit.individualTripDestinationPointLatLng == null
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
                                  target:
                                      cubit.individualTripDestinationPointLatLng!,
                                  zoom: 14.0,
                                ),
                                markers: cubit.individualTripDestinationPointMarkers,
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
                  if (cubit.individualTripDestinationPointAddress != null)
                    Column(
                      children: [
                        SizedBox(height: 20.h),
                        CustomText(
                            text: cubit.individualTripDestinationPointAddress!),
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
