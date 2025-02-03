import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/data/models/home/location/location.dart';

class ViewAllMapLocations extends StatelessWidget {
  final List<Locations> locations;

  const ViewAllMapLocations({super.key, required this.locations});

  @override
  Widget build(BuildContext context) {
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
          text: 'عرض جميع مواقعك',
          fontSize: 16.00.sp,
          fontFamily: FontManager.bold,
          color: ColorsManager.white,
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(double.parse('${locations.first.latitude}'),
              double.parse('${locations.first.longitude}')),
          zoom: 10,
        ),
        markers: locations
            .map(
              (location) => Marker(
                markerId: MarkerId(location.id.toString()),
                position: LatLng(double.parse('${location.latitude}'),
                    double.parse('${location.longitude}')),
                infoWindow: InfoWindow(
                  title: location.nickname,
                  snippet: location.locationName,
                ),
              ),
            )
            .toSet(),
      ),
    );
  }
}
