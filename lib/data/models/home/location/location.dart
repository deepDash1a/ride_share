import 'package:equatable/equatable.dart';
import 'package:ride_share/core/shared/shared_models/base_response_model.dart';

class GetLocationsModel extends BaseResponseModel<List<Locations>> {
  const GetLocationsModel({
    required super.status,
    required super.message,
    super.body,
  });

  factory GetLocationsModel.fromJson(Map<String, dynamic> json) {
    return GetLocationsModel(
      status: json['status'],
      message: json['message'],
      body: List<Locations>.from(
          json['locations'].map((e) => Locations.fromJson(e))).toList(),
    );
  }
}

// ignore: must_be_immutable
class Locations extends Equatable {
  int? id;
  String? nickname;
  String? locationName;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;
  int? userId;

  Locations({
    this.id,
    this.nickname,
    this.locationName,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.userId,
  });

  Locations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickname = json['nickname'];
    locationName = json['location_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nickname'] = nickname;
    data['location_name'] = locationName;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user_id'] = userId;
    return data;
  }

  @override
  List<Object?> get props => [
        id,
        nickname,
        locationName,
        latitude,
        longitude,
        createdAt,
        updatedAt,
        userId,
      ];
}
