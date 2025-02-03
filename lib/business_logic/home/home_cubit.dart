import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences_keys.dart';
import 'package:ride_share/core/themes/images.dart';
import 'package:ride_share/data/models/home/admin_messages.dart';
import 'package:ride_share/data/models/home/chat/chat_model.dart';
import 'package:ride_share/data/models/home/instructions.dart';
import 'package:ride_share/data/models/home/location/location.dart';
import 'package:ride_share/data/models/home/profile/profile.dart';
import 'package:ride_share/data/models/home/wallet/user_balance.dart';
import 'package:ride_share/data/models/maps/place_details_model.dart';
import 'package:ride_share/data/remote_data_source/home_remote_data_source/home_remote_data_source.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRemoteDataSource homeRemoteDataSource;

  HomeCubit(this.homeRemoteDataSource) : super(HomeInitial());

  final emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final passwordRegex = RegExp(r'^(?=.*[A-Za-z]).{8,}$');
  final egyptPhoneRegExp = RegExp(r'^(?:\+20|0)?1[0125]\d{8}$');

  List<InstructionModel> instructionModelList = [
    InstructionModel(image: ImagesManagers.car, title: 'السيارة'),
    InstructionModel(image: ImagesManagers.passengers, title: 'الركاب'),
    InstructionModel(image: ImagesManagers.info, title: 'معلومات عامة'),
  ];

  bool showAllMessages = false;

  // profile section
  XFile? pickImageFromDevice(XFile? imagePath, XFile newImage) {
    imagePath = newImage;
    emit(UploadImageState());
    return imagePath;
  }

  // update profile
  var updateProfileFNameController = TextEditingController();
  var updateProfileLNameController = TextEditingController();
  var updateProfileEmailController = TextEditingController();
  XFile? updateProfileImage;
  var updateProfilePasswordController = TextEditingController();
  bool updateProfilePasswordObSecure = true;
  var updateProfileConfirmPasswordController = TextEditingController();
  bool updateProfileConfirmationPasswordObSecure = true;
  var updateProfilePhoneNumberController = TextEditingController();
  var updateProfileWhatsNumberController = TextEditingController();
  var updateProfileProvinceController = TextEditingController();
  var updateProfileDistrictController = TextEditingController();
  var updateProfileSubDistrictController = TextEditingController();
  var updateProfileStreetController = TextEditingController();
  var updateProfileBuildingController = TextEditingController();
  var updateProfileLandMarkController = TextEditingController();
  LatLng? updateProfileLatLng;

  // trips map section
  void emitSuggestions(String place) {
    homeRemoteDataSource.getSuggestions(place).then((value) {
      emit(PlacesLoadedHome(value));
    });
  }

  void emitPlaceLocation(String placeId) {
    homeRemoteDataSource.getPlaceLocation(placeId).then((value) {
      emit(PlaceDetailsLoadedHome(value));
    });
  }

  // location section
  var setLocationFormKey = GlobalKey<FormState>();
  String? locationAddress;
  LatLng? locationLatLng;
  var locationNickNameController = TextEditingController();
  List<String> locationGovernorates = [];
  List<Map<String, dynamic>> locationDistricts = [];
  List<String> locationSubDistricts = [];
  String? selectedLocationGovernorate;
  String? selectedLocationDistrict;
  String? selectedLocationSubDistrict;

  // general
  void changeVisibilityTrueOrFalse({
    required bool currentVisibility,
    required void Function(bool) updateVisibility,
  }) {
    final newVisibility = !currentVisibility;

    updateVisibility(newVisibility);

    emit(ChangeVisibilityTrueOrFalseAppState());
  }

  GeneralAdminMessagesModel? generalAdminMessagesModel;
  List<AdminMessagesModel> readMessages = [];
  List<AdminMessagesModel> unReadMessages = [];

  Future<void> getAdminMessages() async {
    emit(LoadingAdminMessagesAppState());

    try {
      final response = await homeRemoteDataSource.getAdminMessages();
      generalAdminMessagesModel =
          GeneralAdminMessagesModel.fromJson(response.data);

      if (generalAdminMessagesModel?.body != null) {
        readMessages = generalAdminMessagesModel!.body!
            .where((message) => message.read == true)
            .toList();
        unReadMessages = generalAdminMessagesModel!.body!
            .where((message) => message.read == false)
            .toList();
      }

      emit(SuccessAdminMessagesAppState());
    } catch (error) {
      print(error);
      emit(ErrorAdminMessagesAppState(error: error.toString()));
    }
  }

  Future<void> updateAdminMessages({
    required String content,
    required String priority,
    required bool read,
    required int id,
    required String date,
  }) async {
    emit(LoadingUpdateAdminMessagesAppState());

    try {
      await homeRemoteDataSource.updateAdminMessage(
        content: content,
        priority: priority,
        read: read,
        id: id,
        date: date,
      );
      emit(SuccessUpdateAdminMessagesAppState());
    } catch (error) {
      ErrorUpdateAdminMessagesAppState(error: error.toString());
    }
  }

  GetUserProfileModel? getUserProfileModel;

  Future<void> getUserProfileData() async {
    emit(LoadingGetUserProfileAppState());
    try {
      final response = await homeRemoteDataSource.getUserProfileData();
      getUserProfileModel = GetUserProfileModel.fromJson(response.data);
      print(getUserProfileModel);
      await SharedPreferencesService.saveData(
        key: SharedPreferencesKeys.userId,
        value: getUserProfileModel!.body!.id,
      );

      emit(SuccessGetUserProfileAppState());
    } catch (error) {
      print(error);
      emit(ErrorGetUserProfileAppState(error: error.toString()));
    }
  }

  Future<void> updateUserProfileData() async {
    emit(LoadingUpdateUserProfileAppState());
    try {
      await homeRemoteDataSource.updateUserProfileData(
        firstName: updateProfileFNameController.text,
        lastName: updateProfileLNameController.text,
        email: updateProfileEmailController.text,
        profileImage: updateProfileImage!,
        password: updateProfilePasswordController.text,
        confirmPassword: updateProfileConfirmPasswordController.text,
        phoneNumber: updateProfilePhoneNumberController.text,
        whatsAppNumber: updateProfileWhatsNumberController.text,
        province: updateProfileProvinceController.text,
        district: updateProfileDistrictController.text,
        subDistrict: updateProfileSubDistrictController.text,
        street: updateProfileStreetController.text,
        building: updateProfileBuildingController.text,
        landmark: updateProfileLandMarkController.text,
      );

      emit(SuccessUpdateUserProfileAppState());
    } catch (error) {
      print(error);
      emit(ErrorUpdateUserProfileAppState(error: error.toString()));
    }
  }

  // feed back

  // location
  Future<void> saveLocation() async {
    emit(LoadingSaveLocationAppState());

    try {
      homeRemoteDataSource.saveLocation(
        location: locationAddress!,
        nickname: locationNickNameController.text,
        lat: '${locationLatLng!.latitude}',
        lng: '${locationLatLng!.longitude}',
      );

      emit(SuccessSaveLocationAppState());
    } catch (error) {
      print(error);
      emit(ErrorSaveLocationAppState(error: error.toString()));
    }
  }

  GetLocationsModel? getLocationsModel;

  Future<void> getLocation() async {
    emit(LoadingGetLocationAppState());

    try {
      final response = await homeRemoteDataSource.getLocations();

      getLocationsModel = GetLocationsModel.fromJson(response.data);

      print(getLocationsModel);

      emit(SuccessGetLocationAppState());
    } catch (error) {
      print(error);
      emit(ErrorGetLocationAppState(error: error.toString()));
    }
  }

  GetUserBalance? getUserBalanceModel;

  Future<void> getUserBalance() async {
    emit(LoadingGetLastBalanceAppState());

    try {
      final response = await homeRemoteDataSource.getLastBalance();

      getUserBalanceModel = GetUserBalance.fromJson(response.data);

      emit(SuccessGetLastBalanceAppState());
    } catch (error) {
      print(error);
      emit(ErrorGetLastBalanceAppState(error: error.toString()));
    }
  }


}
