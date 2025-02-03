import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:ride_share/data/api/dio_helper.dart';
import 'package:ride_share/data/api/end_points.dart';
import 'package:ride_share/data/models/maps/place_details_model.dart';
import 'package:ride_share/data/models/maps/places_suggestion.dart';

class AuthRemoteDataSource {
  final DioHelper dioHelper;

  AuthRemoteDataSource(this.dioHelper);

  Future<List<dynamic>> getSuggestions(String place) async {
    try {
      Response response = await dioHelper.getData(
        url: 'https://maps.googleapis.com/maps/api/place/textsearch/json',
        query: {
          'query': place,
          'type': 'address',
          'components': 'country:eg',
          'key': 'AIzaSyBtpz1PYwlJoXX_OC4Mpi9-h4mDzyPZGvM',
        },
      );
      return response.data['results']
          .map((e) => PlacesSuggestion.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> getPlaceLocation(String placeId) async {
    try {
      Response response = await dioHelper.getData(
        url: 'https://maps.googleapis.com/maps/api/place/details/json',
        query: {
          'place_id': placeId,
          'fields': 'geometry',
          'key': 'AIzaSyBtpz1PYwlJoXX_OC4Mpi9-h4mDzyPZGvM',
        },
      );
      return Place.fromJson(response.data);
    } catch (e) {
      return Future.error(
        'Place error: ',
        StackTrace.fromString('this is trace'),
      );
    }
  }

  // login
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    try {
      var data = {
        'email': email,
        'password': password,
      };
      Response response = await dioHelper.postData(
        url: EndPoints.login,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> fcmToken({
    required String fcmToken,
  }) async {
    try {
      Response response = await dioHelper.postData(
        url: EndPoints.fcmToken,
        data: {
          'fcm_token': fcmToken,
        },
      );

      print(fcmToken);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> forgetPassword({
    required String email,
  }) async {
    try {
      Response response = await dioHelper.postData(
        url: EndPoints.forgetPassword,
        data: {
          'email': email,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

// register
  Future<Response> register({
    required String firstName,
    required String secondName,
    required String email,
    XFile? profileImage,
    required String password,
    required String passwordConfirmation,
    required String phoneNumber,
    required String whatsappNumber,
    String? province,
    String? district,
    String? subDistrict,
    String? street,
    String? building,
    String? landmark,
    double? latitude,
    double? longitude,
  }) async {
    try {
      MultipartFile? profileImageMultipart;
      if (profileImage != null) {
        profileImageMultipart = await MultipartFile.fromFile(
          File(profileImage.path).path,
          filename: path.basename(profileImage.path),
        );
      }

      final Map<String, dynamic> data = {
        'first_name': firstName,
        'second_name': secondName,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'phone_number': phoneNumber,
        'whatsapp_number': whatsappNumber,
        if (province != null) 'province': province,
        if (district != null) 'district': district,
        if (subDistrict != null) 'sub_district': subDistrict,
        if (street != null) 'street': street,
        if (building != null) 'building': building,
        if (landmark != null) 'landmark': landmark,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (latitude != null) 'profile_image': latitude,
        if (profileImage != null)
          'profile_image': await MultipartFile.fromFile(
            profileImage.path,
            filename: path.basename(profileImage.path),
          ),
      };

      print(data);

      final response = await dioHelper.postData(
        url: EndPoints.register,
        isFormData: true,
        data: data,
      );

      return response;
    } catch (e) {
      print('Error in register method: $e');
      rethrow;
    }
  }
}
