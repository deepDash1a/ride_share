import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/data/models/maps/places_suggestion.dart';

class PlaceItem extends StatelessWidget {
  final PlacesSuggestion suggestion;

  const PlaceItem({super.key, required this.suggestion});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: ColorsManager.secondaryColor.withOpacity(0.5),
                child: const Icon(
                  Icons.place_outlined,
                  color: ColorsManager.white,
                ),
              ),
              const SizedBox(
                width: 10.00,
              ),
              Expanded(
                child: CustomText(
                  text: suggestion.name,
                  color: ColorsManager.mainColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.00.h),
          CustomText(
            text: suggestion.description,
            color: ColorsManager.secondaryColor,
          ),
        ],
      ),
    );
  }
}
