import 'package:ride_share/core/shared/shared_models/base_response_model.dart';

class GetChatModel extends BaseResponseModel<List<ChatModel>> {
  const GetChatModel({
    required super.status,
    required super.message,
    super.body,
  });

  factory GetChatModel.fromJson(Map<String, dynamic> json) {
    return GetChatModel(
      status: json['status'],
      message: json['message'],
      body: List<ChatModel>.from(
          json['data'].map((e) => ChatModel.fromJson(e))).toList(),
    );
  }
}

class ChatModel {
  int? id;
  String? message;
  String? senderType;
  int? userId;
  int? tripId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  User? user;
  Trip? trip;

  ChatModel({
    this.id,
    this.message,
    this.senderType,
    this.userId,
    this.tripId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
    this.trip,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    senderType = json['sender_type'];
    userId = json['user_id'];
    tripId = json['trip_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    trip = json['trip'] != null ? Trip.fromJson(json['trip']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    data['sender_type'] = senderType;
    data['user_id'] = userId;
    data['trip_id'] = tripId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (trip != null) {
      data['trip'] = trip!.toJson();
    }
    return data;
  }
}

class User {
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
}

class Trip {
  int? id;
  int? userId;
  String? tripDate;
  String? tripType;
  String? codeGroup;
  int? numPassengers;
  String? startTime;
  String? startProvince;
  String? startDistrict;
  String? startSubDistrict;
  String? pickupPoint;
  double? startLatitude;
  double? startLongitude;
  String? endTimeFrom;
  String? endTimeTo;
  String? endProvince;
  String? endDistrict;
  String? endSubDistrict;
  String? destination;
  double? endLatitude;
  double? endLongitude;
  double? expectedDistance;
  String? estimatedArrivalTime;
  String? gender;
  String? seatingOptions;
  String? age;
  int? babies;
  String? status;
  double? initialPrice;
  double? finalPrice;
  String? walletStatus;
  double? trackLatitude;
  double? trackLongitude;
  String? createdAt;
  String? updatedAt;

  Trip({
    this.id,
    this.userId,
    this.tripDate,
    this.tripType,
    this.codeGroup,
    this.numPassengers,
    this.startTime,
    this.startProvince,
    this.startDistrict,
    this.startSubDistrict,
    this.pickupPoint,
    this.startLatitude,
    this.startLongitude,
    this.endTimeFrom,
    this.endTimeTo,
    this.endProvince,
    this.endDistrict,
    this.endSubDistrict,
    this.destination,
    this.endLatitude,
    this.endLongitude,
    this.expectedDistance,
    this.estimatedArrivalTime,
    this.gender,
    this.seatingOptions,
    this.age,
    this.babies,
    this.status,
    this.initialPrice,
    this.finalPrice,
    this.walletStatus,
    this.trackLatitude,
    this.trackLongitude,
    this.createdAt,
    this.updatedAt,
  });

  Trip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    tripDate = json['trip_date'];
    tripType = json['trip_type'];
    codeGroup = json['code_group'];
    numPassengers = json['num_passengers'];
    startTime = json['start_time'];
    startProvince = json['start_province'];
    startDistrict = json['start_district'];
    startSubDistrict = json['start_sub_district'];
    pickupPoint = json['pickup_point'];
    startLatitude = json['start_latitude'];
    startLongitude = json['start_longitude'];
    endTimeFrom = json['end_time_from'];
    endTimeTo = json['end_time_to'];
    endProvince = json['end_province'];
    endDistrict = json['end_district'];
    endSubDistrict = json['end_sub_district'];
    destination = json['destination'];
    endLatitude = json['end_latitude'];
    endLongitude = json['end_longitude'];
    expectedDistance = json['expected_distance'];
    estimatedArrivalTime = json['estimated_arrival_time'];
    gender = json['gender'];
    seatingOptions = json['seating_options'];
    age = json['age'];
    babies = json['babies'];
    status = json['status'];
    initialPrice = json['initial_price'];
    finalPrice = json['final_price'];
    walletStatus = json['wallet_status'];
    trackLatitude = json['track_latitude'];
    trackLongitude = json['track_longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['trip_date'] = tripDate;
    data['trip_type'] = tripType;
    data['code_group'] = codeGroup;
    data['num_passengers'] = numPassengers;
    data['start_time'] = startTime;
    data['start_province'] = startProvince;
    data['start_district'] = startDistrict;
    data['start_sub_district'] = startSubDistrict;
    data['pickup_point'] = pickupPoint;
    data['start_latitude'] = startLatitude;
    data['start_longitude'] = startLongitude;
    data['end_time_from'] = endTimeFrom;
    data['end_time_to'] = endTimeTo;
    data['end_province'] = endProvince;
    data['end_district'] = endDistrict;
    data['end_sub_district'] = endSubDistrict;
    data['destination'] = destination;
    data['end_latitude'] = endLatitude;
    data['end_longitude'] = endLongitude;
    data['expected_distance'] = expectedDistance;
    data['estimated_arrival_time'] = estimatedArrivalTime;
    data['gender'] = gender;
    data['seating_options'] = seatingOptions;
    data['age'] = age;
    data['babies'] = babies;
    data['status'] = status;
    data['initial_price'] = initialPrice;
    data['final_price'] = finalPrice;
    data['wallet_status'] = walletStatus;
    data['track_latitude'] = trackLatitude;
    data['track_longitude'] = trackLongitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
