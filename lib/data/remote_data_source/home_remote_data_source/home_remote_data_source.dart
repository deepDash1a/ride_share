import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:ride_share/data/api/dio_helper.dart';
import 'package:ride_share/data/api/end_points.dart';
import 'package:ride_share/data/models/maps/place_details_model.dart';
import 'package:ride_share/data/models/maps/places_suggestion.dart';

class HomeRemoteDataSource {
  final DioHelper dioHelper;

  HomeRemoteDataSource(this.dioHelper);

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

  Future<Response> getAdminMessages() async {
    try {
      final response = await dioHelper.getData(url: EndPoints.getAdminMessages);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> updateAdminMessage({
    required String content,
    required String priority,
    required bool read,
    required int id,
    required String date,
  }) async {
    try {
      var data = {
        "content": content,
        "priority": priority,
        "read": read,
        "user_id": id,
        "date": date
      };
      final response =
          dioHelper.putData(url: EndPoints.updateAdminMessages(id), data: data);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getUserProfileData() async {
    try {
      final response =
          await dioHelper.getData(url: EndPoints.getUserProfileData);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> updateUserProfileData({
    required String firstName,
    required String lastName,
    required String email,
    required XFile profileImage,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String whatsAppNumber,
    required String province,
    required String district,
    required String subDistrict,
    required String street,
    required String building,
    required String landmark,
  }) async {
    final profileImageFile = File(profileImage.path);
    try {
      var data = {
        'first_name': firstName,
        'second_name': lastName,
        'email': email,
        'profile_image': await MultipartFile.fromFile(
          profileImageFile.path,
          filename: path.basename(profileImageFile.path),
        ),
        'password': password,
        'password_confirmation': confirmPassword,
        'phone_number': phoneNumber,
        'whatsapp_number': whatsAppNumber,
        'province': province,
        'district': district,
        'sub_district': subDistrict,
        'street': street,
        'building': building,
        'landmark': landmark,
      };

      print(data);
      final response = await dioHelper.postData(
        url: EndPoints.updateUserProfileData,
        isFormData: true,
        data: data,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> saveLocation({
    required String location,
    required String nickname,
    required String lat,
    required String lng,
  }) async {
    try {
      var data = {
        'location_name': location,
        'nickname': nickname,
        'latitude': lat,
        'longitude': lng,
      };
      final response = await dioHelper.postData(
        url: EndPoints.savedLocation,
        isFormData: true,
        data: data,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getLocations() async {
    try {
      final response = await dioHelper.getData(
        url: EndPoints.getLocation,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getLastBalance() async {
    try {
      final response = await dioHelper.getData(
        url: EndPoints.getLastBalance,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

}
