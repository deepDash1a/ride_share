import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ride_share/core/shared/functions/functions.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/data/models/home/chat/chat_model.dart';
import 'package:ride_share/data/models/home/trip/trip_model.dart';
import 'package:ride_share/data/models/maps/place_details_model.dart';
import 'package:ride_share/data/remote_data_source/trips_remote_data_source/trips_remote_data_source.dart';

part 'trips_state.dart';

class TripsCubit extends Cubit<TripsState> {
  final TripsRemoteDataSource tripsRemoteDataSource;

  TripsCubit(this.tripsRemoteDataSource) : super(TripsInitial());

  int buildNewGroupTripCurrentStep = 0;
  int buildNewGroupTripTotalSteps = 5;

  double groupProgressValue() {
    return (buildNewGroupTripCurrentStep + 1) / buildNewGroupTripTotalSteps;
  }

  void groupNextStep() {
    if (buildNewGroupTripCurrentStep < buildNewGroupTripTotalSteps - 1) {
      buildNewGroupTripCurrentStep++;
    }
    print('your current step is : $buildNewGroupTripCurrentStep');
  }

  void groupPreviousStep() {
    if (buildNewGroupTripCurrentStep > 0) {
      buildNewGroupTripCurrentStep--;
    }
    print('your current step is : $buildNewGroupTripCurrentStep');
  }

  // individual
  int buildNewIndividualTripCurrentStep = 0;
  int buildNewIndividualTripTotalSteps = 5;

  double individualProgressValue() {
    return (buildNewIndividualTripCurrentStep + 1) /
        buildNewIndividualTripTotalSteps;
  }

  void individualNextStep() {
    if (buildNewIndividualTripCurrentStep <
        buildNewIndividualTripTotalSteps - 1) {
      buildNewIndividualTripCurrentStep++;
    }
    print('your current step is : $buildNewIndividualTripCurrentStep');
  }

  void individualPreviousStep() {
    if (buildNewIndividualTripCurrentStep > 0) {
      buildNewIndividualTripCurrentStep--;
    }
    print('your current step is : $buildNewIndividualTripCurrentStep');
  }

  // group meeting point
  var groupTripMeetingPointFormKey = GlobalKey<FormState>();
  String? groupId;
  var groupTripMeetingPointJoinController = TextEditingController();
  String? groupTripMeetingPointAddress;
  LatLng? groupTripMeetingPointLatLng;
  LatLng? groupTripMeetingPointMapLocation;
  GoogleMapController? groupTripMeetingPointMapController;
  Set<Marker> groupTripMeetingPointMarkers = {};
  List<String> groupTripMeetingPointLocationGovernorates = [];
  List<Map<String, dynamic>> groupTripMeetingPointLocationDistricts = [];
  List<String> groupTripMeetingPointLocationSubDistricts = [];
  String? groupTripMeetingPointSelectedLocationGovernorate;
  String? groupTripMeetingPointSelectedLocationDistrict;
  String? groupTripMeetingPointSelectedLocationSubDistrict;

  // group destination point
  var groupTripDestinationPointFormKey = GlobalKey<FormState>();
  String? groupTripDestinationPointAddress;
  LatLng? groupTripDestinationPointLatLng;
  LatLng? groupTripDestinationPointMapLocation;
  GoogleMapController? groupTripDestinationPointMapController;
  Set<Marker> groupTripDestinationPointMarkers = {};
  List<String> groupTripDestinationPointLocationGovernorates = [];
  List<Map<String, dynamic>> groupTripDestinationPointLocationDistricts = [];
  List<String> groupTripDestinationPointLocationSubDistricts = [];
  String? groupTripDestinationPointSelectedLocationGovernorate;
  String? groupTripDestinationPointSelectedLocationDistrict;
  String? groupTripDestinationPointSelectedLocationSubDistrict;

  // seats and time
  var groupTripTimeAndSeatsFormKey = GlobalKey<FormState>();
  List<DropdownMenuItem<int>> groupTripSeatsList = [
    const DropdownMenuItem(
      value: 1,
      child: CustomText(
        text: 'مقعد',
      ),
    ),
    const DropdownMenuItem(
      value: 2,
      child: CustomText(
        text: 'مقعدان',
      ),
    ),
    const DropdownMenuItem(
      value: 3,
      child: CustomText(
        text: 'ثلاثة مقاعد',
      ),
    ),
  ];
  int? groupTripSeatsListSelectedValue;
  List<int> groupTripSelectedSquares = [];
  DateTime? groupTripSelectedDate;
  String groupTripSelectedDateValue = '';

  void groupAddSeat(int index) {
    if (!groupTripSelectedSquares.contains(index) &&
        groupTripSelectedSquares.length <
            (groupTripSeatsListSelectedValue ?? 0)) {
      groupTripSelectedSquares.add(index);
      print(groupTripSelectedSquares);
      emit(ChangeTripsState());
    }
  }

  void groupRemoveSeat(int index) {
    if (groupTripSelectedSquares.contains(index)) {
      groupTripSelectedSquares.remove(index);
      emit(ChangeTripsState());
    }
  }

  void groupUpdateSelectedSeats(List<int> seats) {
    groupTripSelectedSquares = seats;
    print(groupTripSelectedSquares);
    emit(ChangeTripsState());
  }

  void groupUpdateSeatsCount(int? value) {
    groupTripSeatsListSelectedValue = value;
    groupTripSelectedSquares.clear();
    emit(ChangeTripsState());
  }

  var groupTripSelectDate = TextEditingController();
  var groupTripSelectTimeFrom = TextEditingController();
  var groupTripSelectTimeTo = TextEditingController();

  Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime now = DateTime.now();
    DateTime? piked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 5 * 365)),
    );

    if (piked != null) {
      controller.text = piked.toString().split(" ")[0];
      emit(SelectDateOfMonthlyTripsState());
    }
  }

  Future<void> selectTime(
      BuildContext context, TextEditingController controller) async {
    DateTime now = DateTime.now().add(const Duration(hours: 3));
    TimeOfDay initialTime = TimeOfDay(hour: now.hour, minute: now.minute);

    if (controller == groupTripSelectTimeTo &&
        groupTripSelectTimeFrom.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى تحديد وقت البداية أولًا'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (controller == groupTripSelectTimeTo) {
      List<String> fromTime = groupTripSelectTimeFrom.text.split(':');
      int fromHour = int.parse(fromTime[0]);
      int fromMinute = int.parse(fromTime[1]);

      initialTime = TimeOfDay(hour: fromHour, minute: fromMinute);
    }

    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      DateTime pickedDateTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);

      if (controller == groupTripSelectTimeFrom &&
          pickedDateTime.isBefore(now)) {
        customSnackBar(
          context: context,
          text: 'يجب أن يكون وقت البداية بعد 3 ساعات من الآن أو يساويه',
          color: Colors.red,
        );
        return;
      }

      if (controller == groupTripSelectTimeTo) {
        // تقسيم وقت البداية
        List<String> fromTime = groupTripSelectTimeFrom.text.split(':');
        int fromHour = int.parse(fromTime[0]);
        int fromMinute = int.parse(fromTime[1]);

        DateTime fromDateTime =
            DateTime(now.year, now.month, now.day, fromHour, fromMinute);

        // التأكد من أن وقت النهاية بعد وقت البداية ولو بدقيقة واحدة
        if (pickedDateTime.isBefore(fromDateTime) ||
            pickedDateTime.isAtSameMomentAs(fromDateTime)) {
          customSnackBar(
            context: context,
            text: 'يجب أن يكون وقت النهاية بعد وقت البداية ولو بدقيقة واحدة',
            color: Colors.red,
          );
          return;
        }

        // التأكد من أن وقت النهاية لا يتخطى ساعة واحدة بعد وقت البداية
        DateTime maxAllowedTime = fromDateTime.add(const Duration(hours: 1));

        if (pickedDateTime.isAfter(maxAllowedTime)) {
          customSnackBar(
            context: context,
            text: 'يجب أن يكون وقت النهاية خلال ساعة واحدة فقط من وقت البداية',
            color: Colors.red,
          );
          return;
        }
      }

      controller.text =
          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      emit(SelectTimeOfMonthlyTripsState());
    }
  }

  // add data
  var groupTripPassengerFormKey = GlobalKey<FormState>();
  List<DropdownMenuItem<String>> groupTripGenderList = [
    const DropdownMenuItem(
      value: 'male',
      child: CustomText(
        text: 'ذكر',
      ),
    ),
    const DropdownMenuItem(
      value: 'female',
      child: CustomText(
        text: 'أنثى',
      ),
    ),
  ];
  String? groupTripGenderSelectedValue;
  bool groupHasChildren = false;
  List<DropdownMenuItem<String>> groupTripPassengerAgeList = [
    const DropdownMenuItem(
      value: '10 - 15',
      child: CustomText(
        text: '10 - 15',
      ),
    ),
    const DropdownMenuItem(
      value: '16 - 21',
      child: CustomText(
        text: '16 - 21',
      ),
    ),
    const DropdownMenuItem(
      value: '22 - 27',
      child: CustomText(
        text: '22 - 27',
      ),
    ),
    const DropdownMenuItem(
      value: '28 - 33',
      child: CustomText(
        text: '28 - 33',
      ),
    ),
    const DropdownMenuItem(
      value: '34 - 39',
      child: CustomText(
        text: '34 - 39',
      ),
    ),
    const DropdownMenuItem(
      value: '40 - 45',
      child: CustomText(
        text: '40 - 45',
      ),
    ),
    const DropdownMenuItem(
      value: '46 - 51',
      child: CustomText(
        text: '46 - 51',
      ),
    ),
    const DropdownMenuItem(
      value: '52 - 60',
      child: CustomText(
        text: '52 - 60',
      ),
    ),
  ];
  String? groupTripPassengerAgeSelectedValue;
  List<DropdownMenuItem<String>> groupTripBabiesAgeList = [
    const DropdownMenuItem(
      value: '1 - 3',
      child: CustomText(
        text: '1 - 3',
      ),
    ),
    const DropdownMenuItem(
      value: '3 - 6',
      child: CustomText(
        text: '3 - 6',
      ),
    ),
    const DropdownMenuItem(
      value: '6 - 10',
      child: CustomText(
        text: '6 - 9',
      ),
    ),
  ];
  String? groupTripBabiesAgeSelectedValue;

  void groupToggleHasChildren() {
    groupHasChildren = !groupHasChildren;
    emit(ChangeChildrenAppState());
  }

  // confirm trips
  dynamic groupTripDistance;
  dynamic groupTripDuration;
  double? groupTripStartingPrice;

  Future<void> fetchDistanceAndDuration(LatLng start, LatLng end) async {
    const apiKey = 'AIzaSyBtpz1PYwlJoXX_OC4Mpi9-h4mDzyPZGvM';
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['routes'].isNotEmpty) {
        final route = data['routes'][0];
        final leg = route['legs'][0];

        final distance = leg['distance']['value']; // بترجع بالمتر
        final duration = leg['duration']['value']; // بترجع بالثواني

        groupTripDistance = distance / 1000;
        groupTripDuration = duration / 60;

        if (kDebugMode) {
          print('Distance: ${distance / 1000} km');
          print('Duration: ${duration / 60} minutes');
        }

        groupTripStartingPrice = groupTripDistance * 5;
        print('Price: $groupTripStartingPrice pounds');
      } else {
        if (kDebugMode) {
          print('No routes found');
        }
      }
    } else {
      if (kDebugMode) {
        print('Error: ${response.reasonPhrase}');
      }
    }
  }

  checkGroupTripValid() {
    switch (buildNewGroupTripCurrentStep) {
      case 0:
        return groupTripMeetingPointFormKey.currentState!.validate() &&
            groupTripMeetingPointLatLng != null &&
            groupTripMeetingPointAddress != null;
      case 1:
        return groupTripDestinationPointFormKey.currentState!.validate() &&
            groupTripDestinationPointLatLng != null &&
            groupTripDestinationPointAddress != null;
      case 2:
        return groupTripTimeAndSeatsFormKey.currentState!.validate() &&
            groupTripSeatsListSelectedValue != null &&
            groupTripSelectedSquares.isNotEmpty;

      case 3:
        return groupTripPassengerFormKey.currentState!.validate();
    }
  }

  postTripGroup() async {
    emit(LoadingCreateNewGroupTripAppState());

    try {
      tripsRemoteDataSource.postTripGroup(
        codeGroup: groupTripMeetingPointJoinController.text,
        numPassengers: groupTripSeatsListSelectedValue!,
        tripDate: groupTripSelectDate.text,
        startProvince: '$groupTripMeetingPointSelectedLocationGovernorate',
        startDistrict: '$groupTripMeetingPointSelectedLocationDistrict',
        startSubDistrict: '$groupTripMeetingPointSelectedLocationSubDistrict',
        pickupPoint: '$groupTripMeetingPointAddress',
        startLatitude: groupTripMeetingPointLatLng!.latitude,
        startLongitude: groupTripMeetingPointLatLng!.longitude,
        endProvince: '$groupTripDestinationPointSelectedLocationGovernorate',
        endDistrict: '$groupTripDestinationPointSelectedLocationDistrict',
        endSubDistrict: '$groupTripDestinationPointSelectedLocationSubDistrict',
        destination: '$groupTripDestinationPointAddress',
        endLatitude: groupTripDestinationPointLatLng!.latitude,
        endLongitude: groupTripDestinationPointLatLng!.longitude,
        expectedDistance: groupTripDistance,
        estimatedArrivalTime: '$groupTripDuration',
        endTimeFrom: groupTripSelectTimeFrom.text,
        endTimeTo: groupTripSelectTimeTo.text,
        initialPrice: groupTripStartingPrice!,
        gender: '$groupTripGenderSelectedValue',
        seatingOptions: '$groupTripSelectedSquares',
        age: '$groupTripPassengerAgeSelectedValue',
        babiesAge: '$groupTripBabiesAgeSelectedValue',
        hasChildren: groupHasChildren,
      );
      emit(SuccessCreateNewGroupTripAppState());
    } catch (error) {
      print(error);
      emit(ErrorCreateNewGroupTripAppState(error: error.toString()));
    }
  }

///////////////////////////////////////////////////////
  // group meeting point
  var individualTripMeetingPointFormKey = GlobalKey<FormState>();
  String? individualTripMeetingPointAddress;
  LatLng? individualTripMeetingPointLatLng;
  LatLng? individualTripMeetingPointMapLocation;
  GoogleMapController? individualTripMeetingPointMapController;
  Set<Marker> individualTripMeetingPointMarkers = {};
  List<String> individualTripMeetingPointLocationGovernorates = [];
  List<Map<String, dynamic>> individualTripMeetingPointLocationDistricts = [];
  List<String> individualTripMeetingPointLocationSubDistricts = [];
  String? individualTripMeetingPointSelectedLocationGovernorate;
  String? individualTripMeetingPointSelectedLocationDistrict;
  String? individualTripMeetingPointSelectedLocationSubDistrict;

  // individual destination point
  var individualTripDestinationPointFormKey = GlobalKey<FormState>();
  String? individualTripDestinationPointAddress;
  LatLng? individualTripDestinationPointLatLng;
  LatLng? individualTripDestinationPointMapLocation;
  GoogleMapController? individualTripDestinationPointMapController;
  Set<Marker> individualTripDestinationPointMarkers = {};
  List<String> individualTripDestinationPointLocationGovernorates = [];
  List<Map<String, dynamic>> individualTripDestinationPointLocationDistricts =
      [];
  List<String> individualTripDestinationPointLocationSubDistricts = [];
  String? individualTripDestinationPointSelectedLocationGovernorate;
  String? individualTripDestinationPointSelectedLocationDistrict;
  String? individualTripDestinationPointSelectedLocationSubDistrict;

  // seats and time
  var individualTripTimeAndSeatsFormKey = GlobalKey<FormState>();
  List<DropdownMenuItem<int>> individualTripSeatsList = [
    const DropdownMenuItem(
      value: 1,
      child: CustomText(
        text: 'مقعد',
      ),
    ),
    const DropdownMenuItem(
      value: 2,
      child: CustomText(
        text: 'مقعدان',
      ),
    ),
    const DropdownMenuItem(
      value: 3,
      child: CustomText(
        text: 'ثلاثة مقاعد',
      ),
    ),
  ];
  int? individualTripSeatsListSelectedValue;
  List<int> individualTripSelectedSquares = [];
  DateTime? individualTripSelectedDate;
  String individualTripSelectedDateValue = '';

  void individualAddSeat(int index) {
    if (!individualTripSelectedSquares.contains(index) &&
        individualTripSelectedSquares.length <
            (individualTripSeatsListSelectedValue ?? 0)) {
      individualTripSelectedSquares.add(index);
      print(individualTripSelectedSquares);
      emit(ChangeTripsState());
    }
  }

  void individualRemoveSeat(int index) {
    if (individualTripSelectedSquares.contains(index)) {
      individualTripSelectedSquares.remove(index);
      emit(ChangeTripsState());
    }
  }

  void individualUpdateSelectedSeats(List<int> seats) {
    individualTripSelectedSquares = seats;
    print(individualTripSelectedSquares);
    emit(ChangeTripsState());
  }

  void individualUpdateSeatsCount(int? value) {
    individualTripSeatsListSelectedValue = value;
    individualTripSelectedSquares.clear();
    emit(ChangeTripsState());
  }

  var individualTripSelectDate = TextEditingController();

  Future<void> individualSelectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime now = DateTime.now();
    DateTime? piked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 5 * 365)),
    );

    if (piked != null) {
      controller.text = piked.toString().split(" ")[0];
      emit(SelectDateOfMonthlyTripsState());
    }
  }

  var individualTripSelectTimeFrom = TextEditingController();
  var individualTripSelectTimeTo = TextEditingController();

  Future<void> individualSelectTime(
      BuildContext context, TextEditingController controller) async {
    DateTime now = DateTime.now().add(const Duration(hours: 3));
    TimeOfDay initialTime = TimeOfDay(hour: now.hour, minute: now.minute);

    if (controller == individualTripSelectTimeTo &&
        individualTripSelectTimeFrom.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى تحديد وقت البداية أولًا'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (controller == individualTripSelectTimeTo) {
      List<String> fromTime = individualTripSelectTimeFrom.text.split(':');
      int fromHour = int.parse(fromTime[0]);
      int fromMinute = int.parse(fromTime[1]);

      initialTime = TimeOfDay(hour: fromHour, minute: fromMinute);
    }

    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      DateTime pickedDateTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);

      if (controller == individualTripSelectTimeFrom &&
          pickedDateTime.isBefore(now)) {
        customSnackBar(
          context: context,
          text: 'يجب أن يكون وقت البداية بعد 3 ساعات من الآن أو يساويه',
          color: Colors.red,
        );
        return;
      }

      if (controller == individualTripSelectTimeTo) {
        List<String> fromTime = individualTripSelectTimeFrom.text.split(':');
        int fromHour = int.parse(fromTime[0]);
        int fromMinute = int.parse(fromTime[1]);

        DateTime fromDateTime =
            DateTime(now.year, now.month, now.day, fromHour, fromMinute);

        // التأكد من أن الوقت المختار لا يساوي وقت البداية
        if (pickedDateTime.isBefore(fromDateTime) ||
            pickedDateTime.isAtSameMomentAs(fromDateTime)) {
          customSnackBar(
            context: context,
            text: 'يجب أن يكون وقت النهاية بعد وقت البداية ولو بدقيقة واحدة',
            color: Colors.red,
          );
          return;
        }

        // التأكد من أن وقت النهاية لا يتخطى ساعة واحدة بعد وقت البداية
        DateTime maxAllowedTime = fromDateTime.add(const Duration(hours: 1));

        if (pickedDateTime.isAfter(maxAllowedTime)) {
          customSnackBar(
            context: context,
            text: 'يجب أن يكون وقت النهاية خلال ساعة واحدة فقط من وقت البداية',
            color: Colors.red,
          );
          return;
        }
      }

      controller.text =
          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      emit(SelectTimeOfMonthlyTripsState());
    }
  }

  // add data
  var individualTripPassengerFormKey = GlobalKey<FormState>();
  List<DropdownMenuItem<String>> individualTripGenderList = [
    const DropdownMenuItem(
      value: 'male',
      child: CustomText(
        text: 'ذكر',
      ),
    ),
    const DropdownMenuItem(
      value: 'female',
      child: CustomText(
        text: 'أنثى',
      ),
    ),
  ];
  String? individualTripGenderSelectedValue;
  bool individualHasChildren = false;
  List<DropdownMenuItem<String>> individualTripPassengerAgeList = [
    const DropdownMenuItem(
      value: '10 - 15',
      child: CustomText(
        text: '10 - 15',
      ),
    ),
    const DropdownMenuItem(
      value: '16 - 21',
      child: CustomText(
        text: '16 - 21',
      ),
    ),
    const DropdownMenuItem(
      value: '22 - 27',
      child: CustomText(
        text: '22 - 27',
      ),
    ),
    const DropdownMenuItem(
      value: '28 - 33',
      child: CustomText(
        text: '28 - 33',
      ),
    ),
    const DropdownMenuItem(
      value: '34 - 39',
      child: CustomText(
        text: '34 - 39',
      ),
    ),
    const DropdownMenuItem(
      value: '40 - 45',
      child: CustomText(
        text: '40 - 45',
      ),
    ),
    const DropdownMenuItem(
      value: '46 - 51',
      child: CustomText(
        text: '46 - 51',
      ),
    ),
    const DropdownMenuItem(
      value: '52 - 60',
      child: CustomText(
        text: '52 - 60',
      ),
    ),
  ];
  String? individualTripPassengerAgeSelectedValue;
  List<DropdownMenuItem<String>> individualTripBabiesAgeList = [
    const DropdownMenuItem(
      value: '1 - 3',
      child: CustomText(
        text: '1 - 3',
      ),
    ),
    const DropdownMenuItem(
      value: '3 - 6',
      child: CustomText(
        text: '3 - 6',
      ),
    ),
    const DropdownMenuItem(
      value: '6 - 10',
      child: CustomText(
        text: '6 - 9',
      ),
    ),
  ];
  String? individualTripBabiesAgeSelectedValue;

  void individualToggleHasChildren() {
    individualHasChildren = !individualHasChildren;
    emit(ChangeChildrenAppState());
  }

  // confirm trips
  dynamic individualTripDistance;
  dynamic individualTripDuration;
  double? individualTripStartingPrice;

  Future<void> individualFetchDistanceAndDuration(
      LatLng start, LatLng end) async {
    const apiKey = 'AIzaSyBtpz1PYwlJoXX_OC4Mpi9-h4mDzyPZGvM';
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['routes'].isNotEmpty) {
        final route = data['routes'][0];
        final leg = route['legs'][0];

        final distance = leg['distance']['value']; // بترجع بالمتر
        final duration = leg['duration']['value']; // بترجع بالثواني

        individualTripDistance = distance / 1000;
        individualTripDuration = duration / 60;

        if (kDebugMode) {
          print('Distance: ${distance / 1000} km');
          print('Duration: ${duration / 60} minutes');
        }

        individualTripStartingPrice = individualTripDistance * 5;
        print('Price: $individualTripStartingPrice pounds');
      } else {
        if (kDebugMode) {
          print('No routes found');
        }
      }
    } else {
      if (kDebugMode) {
        print('Error: ${response.reasonPhrase}');
      }
    }
  }

  postTripIndividual() async {
    emit(LoadingCreateNewIndividualTripAppState());

    try {
      tripsRemoteDataSource.postTripIndividual(
        numPassengers: individualTripSeatsListSelectedValue!,
        tripDate: individualTripSelectDate.text,
        startProvince: '$individualTripMeetingPointSelectedLocationGovernorate',
        startDistrict: '$individualTripMeetingPointSelectedLocationDistrict',
        startSubDistrict:
            '$individualTripMeetingPointSelectedLocationSubDistrict',
        pickupPoint: '$individualTripMeetingPointAddress',
        startLatitude: individualTripMeetingPointLatLng!.latitude,
        startLongitude: individualTripMeetingPointLatLng!.longitude,
        endProvince:
            '$individualTripDestinationPointSelectedLocationGovernorate',
        endDistrict: '$individualTripDestinationPointSelectedLocationDistrict',
        endSubDistrict:
            '$individualTripDestinationPointSelectedLocationSubDistrict',
        destination: '$individualTripDestinationPointAddress',
        endLatitude: individualTripDestinationPointLatLng!.latitude,
        endLongitude: individualTripDestinationPointLatLng!.longitude,
        expectedDistance: individualTripDistance,
        estimatedArrivalTime: '$individualTripDuration',
        endTimeFrom: individualTripSelectTimeFrom.text,
        endTimeTo: individualTripSelectTimeTo.text,
        initialPrice: individualTripStartingPrice!,
        gender: '$individualTripGenderSelectedValue',
        seatingOptions: '$individualTripSelectedSquares',
        age: '$individualTripPassengerAgeSelectedValue',
        babiesAge: '$individualTripBabiesAgeSelectedValue',
        hasChildren: individualHasChildren,
      );
      emit(SuccessCreateNewIndividualTripAppState());
    } catch (error) {
      print(error);
      emit(ErrorCreateNewIndividualTripAppState(error: error.toString()));
    }
  }

  checkIndividualTripValid() {
    switch (buildNewIndividualTripCurrentStep) {
      case 0:
        return individualTripMeetingPointFormKey.currentState!.validate() &&
            individualTripMeetingPointLatLng != null &&
            individualTripMeetingPointAddress != null;
      case 1:
        return individualTripDestinationPointFormKey.currentState!.validate() &&
            individualTripDestinationPointLatLng != null &&
            individualTripDestinationPointAddress != null;
      case 2:
        return individualTripTimeAndSeatsFormKey.currentState!.validate() &&
            individualTripSeatsListSelectedValue != null &&
            individualTripSelectedSquares.isNotEmpty;

      case 3:
        return individualTripPassengerFormKey.currentState!.validate();
    }
  }

  // functions deals with data

  GetTripModel? getAllTripModel;

  Future<void> getAllTrips() async {
    emit(LoadingGetAllTripsAppState());

    try {
      final response = await tripsRemoteDataSource.getAllTrips();

      getAllTripModel = GetTripModel.fromJson(response.data);
      emit(SuccessGetAllTripsAppState());
    } catch (error) {
      print('Error: $error');
      emit(ErrorGetAllTripsAppState(error: error.toString()));
    }
  }

  refreshState() {
    emit(RefreshState());
  }

  // trips status
  GetTripModel? pendingTripsModel;

  Future<void> getPendingTrips() async {
    emit(LoadingGetPendingTripsAppState());

    try {
      final response = await tripsRemoteDataSource.getPendingTrips();

      pendingTripsModel = GetTripModel.fromJson(response.data);

      emit(SuccessGetPendingTripsAppState());
    } catch (error) {
      print('Error: $error');
      emit(ErrorGetPendingTripsAppState());
    }
  }

  GetTripModel? approvedTripsModel;

  Future<void> getApprovedTrips() async {
    emit(LoadingGetApprovedTripsAppState());

    try {
      final response = await tripsRemoteDataSource.getApprovedTrips();
      approvedTripsModel = GetTripModel.fromJson(response.data);

      emit(SuccessGetApprovedTripsAppState());
    } catch (error) {
      print('Error: $error');
      emit(ErrorGetApprovedTripsAppState());
    }
  }

  GetTripModel? inProgressTripsModel;

  Future<void> getInProgressTrips() async {
    emit(LoadingGetInProgressTripsAppState());

    try {
      final response = await tripsRemoteDataSource.getInProgressTrips();

      inProgressTripsModel = GetTripModel.fromJson(response.data);

      emit(SuccessGetInProgressTripsAppState());
    } catch (error) {
      print('Error: $error');
      emit(ErrorGetInProgressTripsAppState());
    }
  }

  GetTripModel? completedTripsModel;

  Future<void> getCompletedTrips() async {
    emit(LoadingGetCompletedTripsAppState());

    try {
      final response = await tripsRemoteDataSource.getCompletedTrips();

      completedTripsModel = GetTripModel.fromJson(response.data);

      emit(SuccessGetCompletedTripsAppState());
    } catch (error) {
      print('Error: $error');
      emit(ErrorGetCompletedTripsAppState());
    }
  }

  GetTripModel? rejectedTripsModel;

  Future<void> getRejectedTrips() async {
    emit(LoadingGetRejectedTripsAppState());

    try {
      final response = await tripsRemoteDataSource.getRejectedTrips();

      rejectedTripsModel = GetTripModel.fromJson(response.data);

      emit(SuccessGetRejectedTripsAppState());
    } catch (error) {
      print('Error: $error');
      emit(ErrorGetRejectedTripsAppState());
    }
  }

  GetTripModel? canceledTripsModel;

  Future<void> getCanceledTrips() async {
    emit(LoadingGetCanceledTripsAppState());

    try {
      final response = await tripsRemoteDataSource.getCanceledTrips();
      ;

      canceledTripsModel = GetTripModel.fromJson(response.data);

      emit(SuccessGetCanceledTripsAppState());
    } catch (error) {
      print('Error: $error');
      emit(ErrorGetCanceledTripsAppState());
    }
  }

  List<TripModel> chatTrips = [];

  Future<void> getAllChatTrips() async {
    emit(LoadingChatTripAppState());

    try {
      final pending = await tripsRemoteDataSource.getPendingTrips();
      final approved = await tripsRemoteDataSource.getApprovedTrips();
      final inProgress = await tripsRemoteDataSource.getInProgressTrips();
      final completed = await tripsRemoteDataSource.getCompletedTrips();
      final can = await tripsRemoteDataSource.getCanceledTrips();

      chatTrips = [];
      chatTrips.addAll(GetTripModel.fromJson(pending.data).body!);
      chatTrips.addAll(GetTripModel.fromJson(approved.data).body!);
      chatTrips.addAll(GetTripModel.fromJson(inProgress.data).body!);
      chatTrips.addAll(GetTripModel.fromJson(completed.data).body!);

      emit(SuccessChatTripAppState());
    } catch (error) {
      emit(ErrorChatTripAppState(error: error.toString()));
    }
  }

  updateTripCanceled({required int id}) async {
    emit(LoadingUpdateCanceledTripAppState());

    try {
      tripsRemoteDataSource.updateTripCanceled(id: id);
      emit(SuccessUpdateCanceledTripAppState());
    } catch (error) {
      print(error);
      emit(ErrorUpdateCanceledTripAppState(error: error.toString()));
    }
  }

  // feed back

  int feedBackRate = 0;
  var feedBackNotesController = TextEditingController();

  Future<void> saveFeedBack({
    required int tripId,
  }) async {
    emit(LoadingSaveTripFeedBackAppState());

    try {
      tripsRemoteDataSource.saveFeedBack(
        tripId: tripId,
        rating: feedBackRate as int,
        feedback: feedBackNotesController.text,
      );

      emit(SuccessSaveTripFeedBackAppState());
    } catch (error) {
      print(error);
      emit(ErrorSaveTripFeedBackAppState(error: error.toString()));
    }
  }

  // chat

  Future<void> storeConversation({
    required String message,
    required int tripId,
  }) async {
    emit(LoadingStoreConversationAppState());

    try {
      tripsRemoteDataSource.storeConversation(
        message: message,
        tripId: tripId,
      );
      emit(SuccessStoreConversationAppState());
    } catch (error) {
      print(error);
      emit(ErrorStoreConversationAppState(error: error.toString()));
    }
  }

  GetChatModel? getChatModel;

  Future<void> getConversation() async {
    emit(LoadingGetConversationAppState());

    try {
      final response = await tripsRemoteDataSource.getConversation();

      getChatModel = GetChatModel.fromJson(response.data);

      print('getChatModel: $getChatModel');

      emit(SuccessGetConversationAppState());
    } catch (error) {
      print(error);
      emit(ErrorGetConversationAppState(error: error.toString()));
    }
  }

  GetChatModel? getCustomChatModel;

  Future<void> getCustomConversation({required int id}) async {
    emit(LoadingGetCustomConversationAppState());

    try {
      final response =
          await tripsRemoteDataSource.getCustomConversation(id: id);

      getCustomChatModel = GetChatModel.fromJson(response.data);

      emit(SuccessGetCustomConversationAppState());
    } catch (error) {
      print(error);
      emit(ErrorGetCustomConversationAppState(error: error.toString()));
    }
  }
}
