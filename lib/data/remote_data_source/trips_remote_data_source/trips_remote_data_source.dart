import 'package:dio/dio.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences_keys.dart';
import 'package:ride_share/data/api/dio_helper.dart';
import 'package:ride_share/data/api/end_points.dart';
import 'package:ride_share/data/models/maps/place_details_model.dart';
import 'package:ride_share/data/models/maps/places_suggestion.dart';

class TripsRemoteDataSource {
  final DioHelper dioHelper;

  TripsRemoteDataSource(this.dioHelper);

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

  // create trips
  Future<Response> postTripIndividual({
    required int numPassengers,
    required String tripDate,
    required String startProvince,
    required String startDistrict,
    required String startSubDistrict,
    required String pickupPoint,
    required double startLatitude,
    required double startLongitude,
    required String endProvince,
    required String endDistrict,
    required String endSubDistrict,
    required String destination,
    required double endLatitude,
    required double endLongitude,
    required double expectedDistance,
    required String estimatedArrivalTime,
    required String endTimeFrom,
    required String endTimeTo,
    required double initialPrice,
    required String gender,
    required String seatingOptions,
    required String age,
    required String babiesAge,
    required bool hasChildren,
  }) async {
    try {
      var data = {
        "user_id":
            SharedPreferencesService.getData(key: SharedPreferencesKeys.userId),
        "trip_type": "individual",
        "num_passengers": numPassengers,
        "trip_date": tripDate,
        "start_province": startProvince,
        "start_district": startDistrict,
        "start_sub_district": startSubDistrict,
        "pickup_point": pickupPoint,
        "start_latitude": startLatitude,
        "start_longitude": startLongitude,
        "end_province": endProvince,
        "end_district": endDistrict,
        "end_sub_district": endSubDistrict,
        "destination": destination,
        "end_latitude": endLatitude,
        "end_longitude": endLongitude,
        "expected_distance": expectedDistance,
        "estimated_arrival_time": estimatedArrivalTime,
        "end_time_from": endTimeFrom,
        "end_time_to": endTimeTo,
        "initial_price": initialPrice,
        "gender": gender,
        "seating_options": seatingOptions,
        "age": age,
        "babies_age": babiesAge,
        "babies": hasChildren
      };
      print(data);
      final response = await dioHelper.postData(
        url: EndPoints.createNewIndividualTrip,
        data: data,
      );
      print(data);

      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> postTripGroup({
    required String codeGroup,
    required int numPassengers,
    required String tripDate,
    required String startProvince,
    required String startDistrict,
    required String startSubDistrict,
    required String pickupPoint,
    required double startLatitude,
    required double startLongitude,
    required String endProvince,
    required String endDistrict,
    required String endSubDistrict,
    required String destination,
    required double endLatitude,
    required double endLongitude,
    required double expectedDistance,
    required String estimatedArrivalTime,
    required String endTimeFrom,
    required String endTimeTo,
    required double initialPrice,
    required String gender,
    required String seatingOptions,
    required String age,
    required String babiesAge,
    required bool hasChildren,
  }) async {
    try {
      var data = {
        "user_id":
            SharedPreferencesService.getData(key: SharedPreferencesKeys.userId),
        "trip_type": 'group',
        "code_group": codeGroup,
        "num_passengers": numPassengers,
        "trip_date": tripDate,
        "start_province": startProvince,
        "start_district": startDistrict,
        "start_sub_district": startSubDistrict,
        "pickup_point": pickupPoint,
        "start_latitude": startLatitude,
        "start_longitude": startLongitude,
        "end_province": endProvince,
        "end_district": endDistrict,
        "end_sub_district": endSubDistrict,
        "destination": destination,
        "end_latitude": endLatitude,
        "end_longitude": endLongitude,
        "expected_distance": expectedDistance,
        "estimated_arrival_time": estimatedArrivalTime,
        "end_time_from": endTimeFrom,
        "end_time_to": endTimeTo,
        "initial_price": initialPrice,
        "gender": gender,
        "seating_options": seatingOptions,
        "age": age,
        "babies_age": babiesAge,
        "babies": hasChildren,
      };
      print(data);

      final response = await dioHelper.postData(
        url: EndPoints.createNewGroupTrip,
        data: data,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getAllTrips() async {
    try {
      final response = await dioHelper.getData(
        url: EndPoints.getTrips,
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to fetch trips: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (error) {
      rethrow;
    }
  }

  // trips status
  Future<Response> getPendingTrips() async {
    try {
      final response = await dioHelper.getData(
        url: EndPoints.getPendingTrips,
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to fetch trips: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getApprovedTrips() async {
    try {
      final response = await dioHelper.getData(
        url: EndPoints.getApprovedTrips,
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to fetch trips: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getInProgressTrips() async {
    try {
      final response = await dioHelper.getData(
        url: EndPoints.getInProgressTrips,
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to fetch trips: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getCompletedTrips() async {
    try {
      final response = await dioHelper.getData(
        url: EndPoints.getCompletedTrips,
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to fetch trips: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getRejectedTrips() async {
    try {
      final response = await dioHelper.getData(
        url: EndPoints.getRejectedTrips,
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to fetch trips: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getCanceledTrips() async {
    try {
      final response = await dioHelper.getData(
        url: EndPoints.getCanceledTrips,
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to fetch trips: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> updateTripCanceled({required int id}) async {
    try {
      final response = await dioHelper.postData(
        url: EndPoints.updateTripCanceled(id: id),
        data: {},
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> saveFeedBack({
    required int tripId,
    required int rating,
    required String feedback,
  }) async {
    try {
      var data = {
        "trip_id": tripId,
        "user_id": await SharedPreferencesService.getData(
            key: SharedPreferencesKeys.userId),
        "rating": rating,
        "feedback": feedback
      };
      final response = await dioHelper.postData(
        url: EndPoints.storeFeedBack,
        isFormData: true,
        data: data,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getConversation() async {
    try {
      final response = await dioHelper.getData(
        url: EndPoints.conversation,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getCustomConversation({required int id}) async {
    try {
      final response = await dioHelper.getData(
        url: EndPoints.getCustomConversation(id: id),
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> storeConversation({
    required String message,
    required int tripId,
  }) async {
    try {
      final response = await dioHelper.postData(
        data: {
          "message": message,
          "trip_id": tripId,
        },
        url: EndPoints.storeConversation,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
