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
import 'package:ride_share/business_logic/auth/auth_cubit.dart';
import 'package:ride_share/core/shared/functions/functions.dart';
import 'package:ride_share/core/shared/widgets/custom_drop_down.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/shared/widgets/custom_text_form_field.dart';
import 'package:ride_share/core/themes/images.dart';

class RegisterMap extends StatefulWidget {
  const RegisterMap({super.key});

  @override
  State<RegisterMap> createState() => _RegisterMapState();
}

class _RegisterMapState extends State<RegisterMap> {
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
      context.read<AuthCubit>().registerLocationGovernorates =
          List<String>.from(
        jsonData['governorates']?.map((governorate) => governorate['name']) ??
            [],
      );
    });
  }

  void updateDistricts(String governorate) {
    setState(() {
      context.read<AuthCubit>().registerLocationDistricts =
          List<Map<String, dynamic>>.from(
        jsonData['governorates']?.firstWhere(
              (g) => g['name'] == governorate,
              orElse: () => {'districts': []},
            )['districts'] ??
            [],
      );
      context.read<AuthCubit>().registerSelectedLocationDistrict = null;
      context.read<AuthCubit>().registerLocationSubDistricts = [];
      context.read<AuthCubit>().registerSelectedLocationSubDistrict = null;
    });
  }

  void updateSubDistricts(String district) {
    final selectedDistrictData =
        context.read<AuthCubit>().registerLocationDistricts.firstWhere(
              (d) => d['name'] == district,
              orElse: () => {'subDistricts': []},
            );

    setState(() {
      context.read<AuthCubit>().registerLocationSubDistricts =
          List<String>.from(selectedDistrictData['sub_districts'] ?? []);
      context.read<AuthCubit>().registerSelectedLocationSubDistrict = null;
    });
  }

  Future<void> showMapForSubDistrict() async {
    final governmentName =
        context.read<AuthCubit>().registerSelectedLocationGovernorate;
    final districtName =
        context.read<AuthCubit>().registerSelectedLocationDistrict;
    final subDistrictName =
        context.read<AuthCubit>().registerSelectedLocationSubDistrict;

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
              context.read<AuthCubit>().registerMapLocation =
                  LatLng(latitude, longitude);
              context.read<AuthCubit>().registerLatLng =
                  context.read<AuthCubit>().registerMapLocation;
              context.read<AuthCubit>().registerMarkers.clear();
              context.read<AuthCubit>().registerMarkers.add(
                    Marker(
                      markerId: MarkerId(subDistrictName),
                      position: context.read<AuthCubit>().registerLatLng!,
                      infoWindow: InfoWindow(title: subDistrictName),
                    ),
                  );
            });

            context.read<AuthCubit>().registerMapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                      context.read<AuthCubit>().registerLatLng!, 16.0),
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
          text: 'فشل الاتصال بالخادم. تحقق من اتصالك بالإنترنت.',
          color: Colors.red,
        );
      }
    }
  }

  void onMapTapped(LatLng tappedPoint) async {
    setState(() {
      context.read<AuthCubit>().registerMarkers.clear();
      context.read<AuthCubit>().registerMarkers.add(
            Marker(
              markerId: const MarkerId("tappedLocation"),
              position: tappedPoint,
              infoWindow: const InfoWindow(title: "New Location"),
            ),
          );
      context.read<AuthCubit>().registerLatLng = tappedPoint;
    });

    try {
      List<Placemark> placemarks = await GeocodingPlatform.instance!
          .placemarkFromCoordinates(
              tappedPoint.latitude, tappedPoint.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = '${place.street}, ${place.locality}, ${place.country}';

        context.read<AuthCubit>().registerAddress = address;
        print("Address: $address");

        setState(() {
          context.read<AuthCubit>().registerMarkers.clear();
          context.read<AuthCubit>().registerMarkers.add(
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
      context.read<AuthCubit>().registerMapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AuthCubit>();
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: cubit.registerMapFormKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomDropDownButton(
                      hint: const CustomText(text: 'اختر المحافظة'),
                      value: cubit.registerSelectedLocationGovernorate,
                      items:
                          cubit.registerLocationGovernorates.map((governorate) {
                        return DropdownMenuItem(
                          value: governorate,
                          child: CustomText(text: governorate),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          cubit.registerSelectedLocationGovernorate = value!;
                          updateDistricts(value);
                        });
                      },
                    ),
                    SizedBox(height: 20.h),
                    CustomDropDownButton(
                      hint: const CustomText(text: 'اختر اللواء أو المركز'),
                      value: cubit.registerSelectedLocationDistrict,
                      items: cubit.registerLocationDistricts.map((district) {
                        return DropdownMenuItem(
                          value: district['name'],
                          child: CustomText(text: district['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          cubit.registerSelectedLocationDistrict =
                              value!.toString();
                          updateSubDistricts(value.toString());
                        });
                      },
                    ),
                    SizedBox(height: 20.h),
                    CustomDropDownButton(
                      hint: const CustomText(text: 'اختر الناحية أو المنطقة'),
                      value: cubit.registerSelectedLocationSubDistrict,
                      items:
                          cubit.registerLocationSubDistricts.map((subDistrict) {
                        return DropdownMenuItem(
                          value: subDistrict,
                          child: CustomText(text: subDistrict),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          cubit.registerSelectedLocationSubDistrict = value!;
                          showMapForSubDistrict();
                        });
                      },
                    ),
                    SizedBox(height: 20.h),
                    cubit.registerLatLng == null
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
                                    target: cubit.registerLatLng!,
                                    zoom: 14.0,
                                  ),
                                  markers: cubit.registerMarkers,
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
                    if (cubit.registerAddress != null)
                      Column(
                        children: [
                          SizedBox(height: 20.h),
                          CustomText(text: cubit.registerAddress!),
                        ],
                      ),
                    SizedBox(height: 20.h),
                    const CustomText(text: 'قم بإكمال بياناتك'),
                    SizedBox(height: 20.h),
                    CustomTextFormField(
                      hintText: 'المحافظة',
                      prefixIcon: SvgPicture.asset(
                        ImagesManagers.governorate,
                        height: 10.h,
                      ),
                      controller: cubit.registerGovernorateController,
                      inputType: TextInputType.name,
                    ),
                    SizedBox(height: 20.h),
                    CustomTextFormField(
                      hintText: 'المنطقة السكنية',
                      prefixIcon: SvgPicture.asset(
                        ImagesManagers.residentialArea,
                        height: 10.h,
                      ),
                      controller: cubit.registerResidentialAreaController,
                      inputType: TextInputType.name,
                    ),
                    SizedBox(height: 20.h),
                    CustomTextFormField(
                      hintText: 'الحي',
                      prefixIcon: SvgPicture.asset(
                        ImagesManagers.neighborhood,
                        height: 10.h,
                      ),
                      controller: cubit.registerNeighborhoodController,
                      inputType: TextInputType.name,
                    ),
                    SizedBox(height: 20.h),
                    CustomTextFormField(
                      hintText: 'الشارع',
                      prefixIcon: SvgPicture.asset(
                        ImagesManagers.street,
                        height: 10.h,
                      ),
                      controller: cubit.registerStreetController,
                      inputType: TextInputType.name,
                    ),
                    SizedBox(height: 20.h),
                    CustomTextFormField(
                      hintText: 'العمارة',
                      prefixIcon: SvgPicture.asset(
                        ImagesManagers.building,
                        height: 10.h,
                      ),
                      controller: cubit.registerBuildingController,
                      inputType: TextInputType.name,
                    ),
                    SizedBox(height: 20.h),
                    CustomTextFormField(
                      hintText: 'علامة مميزة',
                      prefixIcon: SvgPicture.asset(
                        ImagesManagers.distinctiveMark,
                        height: 10.h,
                      ),
                      controller: cubit.registerDistinctiveMarkController,
                      inputType: TextInputType.name,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
