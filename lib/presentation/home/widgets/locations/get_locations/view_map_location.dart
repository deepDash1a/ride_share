import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/themes/colors.dart';

class ViewMapLocation extends StatelessWidget {
  final String locationName;
  final double latitude;
  final double longitude;

  const ViewMapLocation({
    super.key,
    required this.locationName,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final CameraPosition initialPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.0,
    );

    final Marker marker = Marker(
      markerId: MarkerId(locationName),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
        title: locationName,
      ),
    );

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
          text: locationName,
          color: ColorsManager.white,
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: initialPosition,
        markers: {marker},
      ),
    );
  }
}
