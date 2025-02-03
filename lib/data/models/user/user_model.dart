import 'package:ride_share/core/shared/shared_models/base_response_model.dart';

class GeneralUserModel extends BaseResponseModel<UserModel> {
  const GeneralUserModel({
    required super.status,
    required super.message,
    super.body,
    super.token,
  });

  factory GeneralUserModel.fromJson(Map<String, dynamic> json) {
    return GeneralUserModel(
      status: json['status'],
      message: json['message'],
      body: UserModel.fromJson(json['user']),
      token: json['token'],
    );
  }
}

class UserModel {
  String? status;
  User? user;
  String? token;

  UserModel({this.status, this.user, this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class User {
  String? firstName;
  String? secondName;
  String? email;
  String? phoneNumber;
  String? whatsappNumber;
  String? profileImage;
  String? province;
  String? district;
  String? subDistrict;
  String? street;
  String? building;
  String? landmark;
  double? latitude;
  double? longitude;
  String? updatedAt;
  String? createdAt;
  int? id;

  User({
    this.firstName,
    this.secondName,
    this.email,
    this.phoneNumber,
    this.whatsappNumber,
    this.profileImage,
    this.province,
    this.district,
    this.subDistrict,
    this.street,
    this.building,
    this.landmark,
    this.latitude,
    this.longitude,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    secondName = json['second_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    whatsappNumber = json['whatsapp_number'];
    profileImage = json['profile_image'];
    province = json['province'];
    district = json['district'];
    subDistrict = json['sub_district'];
    street = json['street'];
    building = json['building'];
    landmark = json['landmark'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['second_name'] = secondName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['whatsapp_number'] = whatsappNumber;
    data['profile_image'] = profileImage;
    data['province'] = province;
    data['district'] = district;
    data['sub_district'] = subDistrict;
    data['street'] = street;
    data['building'] = building;
    data['landmark'] = landmark;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
