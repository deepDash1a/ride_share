import 'package:equatable/equatable.dart';
import 'package:ride_share/core/shared/shared_models/base_response_model.dart';

class GetUserProfileModel extends BaseResponseModel<User> {
  const GetUserProfileModel({
    required super.status,
    required super.message,
    super.body,
  });

  factory GetUserProfileModel.fromJson(Map<String, dynamic> json) {
    return GetUserProfileModel(
      status: json['status'],
      message: json['message'],
      body: User.fromJson(json['user']),
    );
  }
}

// ignore: must_be_immutable
class User extends Equatable {
  int? id;
  String? firstName;
  String? secondName;
  String? email;
  String? phoneNumber;
  String? whatsappNumber;
  String? profileImage;
  String? province;
  String? district;
  String? subDistrict;
  String? building;
  String? street;
  String? landmark;
  double? latitude;
  double? longitude;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  User({
    this.id,
    this.firstName,
    this.secondName,
    this.email,
    this.phoneNumber,
    this.whatsappNumber,
    this.profileImage,
    this.province,
    this.district,
    this.subDistrict,
    this.building,
    this.street,
    this.landmark,
    this.latitude,
    this.longitude,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    secondName = json['second_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    whatsappNumber = json['whatsapp_number'];
    profileImage = json['profile_image'];
    province = json['province'];
    district = json['district'];
    subDistrict = json['sub_district'];
    building = json['building'];
    street = json['street'];
    landmark = json['landmark'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['second_name'] = secondName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['whatsapp_number'] = whatsappNumber;
    data['profile_image'] = profileImage;
    data['province'] = province;
    data['district'] = district;
    data['sub_district'] = subDistrict;
    data['building'] = building;
    data['street'] = street;
    data['landmark'] = landmark;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        secondName,
        email,
        phoneNumber,
        whatsappNumber,
        profileImage,
        province,
        district,
        subDistrict,
        building,
        street,
        landmark,
        latitude,
        longitude,
        emailVerifiedAt,
        createdAt,
        updatedAt,
      ];
}
