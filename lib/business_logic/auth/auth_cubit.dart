import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_share/core/shared/notification_helper/notification_helper.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences_keys.dart';
import 'package:ride_share/data/models/maps/place_details_model.dart';
import 'package:ride_share/data/models/user/user_model.dart';
import 'package:ride_share/data/remote_data_source/auth_remote_data_source/auth_remote_data_source.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthCubit(this.authRemoteDataSource) : super(AuthInitial());

  final emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final passwordRegex = RegExp(r'^(?=.*[A-Za-z]).{8,}$');
  final egyptPhoneRegExp = RegExp(r'^(?:\+20|0)?1[0125]\d{8}$');

  // login section
  var loginEmailController = TextEditingController();
  var loginPasswordController = TextEditingController();
  var forgetPasswordEmailController = TextEditingController();
  bool loginPasswordObscureText = true;

  GeneralUserModel? generalUserModel;

  Future<void> login() async {
    emit(LoadingLoginAppState());

    try {
      final response = await authRemoteDataSource.login(
        email: loginEmailController.text,
        password: loginPasswordController.text,
      );

      generalUserModel = GeneralUserModel.fromJson(response.data);

      await SharedPreferencesService.saveData(
        key: SharedPreferencesKeys.userToken,
        value: generalUserModel?.token,
      );
      emit(SuccessLoginAppState(generalUserModel: generalUserModel!));
    } catch (error) {
      emit(ErrorLoginAppState(error: error.toString()));
    }
  }

  Future<void> senFcmToken() async {
    emit(LoadingFcmTokenAppState());

    String fcmTokenString = FCMNotificationService().fcmToken!;
    try {
      await authRemoteDataSource.fcmToken(
        fcmToken: fcmTokenString,
      );
      emit(SuccessFcmTokenAppState());
    } catch (error) {
      emit(ErrorFcmTokenAppState(error: error.toString()));
    }
  }

  Future<void> forgetPassword() async {
    emit(LoadingForgetPasswordAppState());

    try {
      await authRemoteDataSource.forgetPassword(
          email: forgetPasswordEmailController.text);
      emit(SuccessForgetPasswordAppState());
    } catch (error) {
      emit(ErrorForgetPasswordAppState(error: error.toString()));
    }
  }

  // main Register

  int buildRegisterCurrentStep = 0;
  int buildRegisterTotalSteps = 2;

  double progressValue() {
    return (buildRegisterCurrentStep + 1) / buildRegisterTotalSteps;
  }

  void nextStep() {
    if (buildRegisterCurrentStep < buildRegisterTotalSteps - 1) {
      buildRegisterCurrentStep++;
    }
  }

  void previousStep() {
    if (buildRegisterCurrentStep > 0) {
      buildRegisterCurrentStep--;
    }
  }

  // register map section
  void emitSuggestions(String place) {
    authRemoteDataSource.getSuggestions(place).then((value) {
      emit(PlacesLoadedAuth(value));
    });
  }

  void emitPlaceLocation(String placeId) {
    authRemoteDataSource.getPlaceLocation(placeId).then((value) {
      emit(PlaceDetailsLoadedAuth(value));
    });
  }

  // register section
  var registerFormKey = GlobalKey<FormState>();
  XFile? registerProfileImage;
  var registerFNameController = TextEditingController();
  var registerLNameController = TextEditingController();
  var registerEmailController = TextEditingController();
  var registerPasswordController = TextEditingController();
  bool registerPasswordObscureText = true;
  var registerConfirmPasswordController = TextEditingController();
  bool registerConfirmPasswordObscureText = true;
  var registerPhoneController = TextEditingController();
  var registerWhatsAppController = TextEditingController();

  var registerMapFormKey = GlobalKey<FormState>();
  Map<String, dynamic> addressDescriptiveRegister = {};
  var registerGovernorateController = TextEditingController();
  var registerResidentialAreaController = TextEditingController();
  var registerNeighborhoodController = TextEditingController();
  var registerStreetController = TextEditingController();
  var registerBuildingController = TextEditingController();
  var registerDistinctiveMarkController = TextEditingController();

  String? registerAddress;
  LatLng? registerLatLng;
  LatLng? registerMapLocation;
  GoogleMapController? registerMapController;
  Set<Marker> registerMarkers = {};
  List<String> registerLocationGovernorates = [];
  List<Map<String, dynamic>> registerLocationDistricts = [];
  List<String> registerLocationSubDistricts = [];
  String? registerSelectedLocationGovernorate;
  String? registerSelectedLocationDistrict;
  String? registerSelectedLocationSubDistrict;

  Future<void> register() async {
    emit(LoadingRegisterAppState());

    try {
      final response = await authRemoteDataSource.register(
        firstName: registerFNameController.text,
        secondName: registerLNameController.text,
        email: registerEmailController.text,
        profileImage: registerProfileImage,
        password: registerPasswordController.text,
        passwordConfirmation: registerConfirmPasswordController.text,
        phoneNumber: registerPhoneController.text,
        whatsappNumber: registerWhatsAppController.text,
        province: registerGovernorateController.text,
        district: registerResidentialAreaController.text,
        subDistrict: registerNeighborhoodController.text,
        street: registerStreetController.text,
        building: registerBuildingController.text,
        landmark: registerDistinctiveMarkController.text,
        latitude: registerLatLng?.latitude,
        longitude: registerLatLng?.longitude,
      );

      print(response);
      emit(SuccessRegisterAppState());
    } catch (error) {
      print(error.toString());
      emit(ErrorRegisterAppState(error: error.toString()));
    }
  }

  void changeVisibilityTrueOrFalse({
    required bool currentVisibility,
    required void Function(bool) updateVisibility,
  }) {
    final newVisibility = !currentVisibility;

    updateVisibility(newVisibility);

    emit(ChangeVisibilityTrueOrFalseAppState());
  }

  XFile? pickImageFromDevice(XFile? imagePath, XFile newImage) {
    imagePath = newImage;
    emit(UploadImageState());
    return imagePath;
  }

  checkRegisterValid() {
    switch (buildRegisterCurrentStep) {
      case 0:
        return registerFormKey.currentState!.validate() &&
            registerPasswordController.text ==
                registerConfirmPasswordController.text;
      case 1:
        return registerMapFormKey.currentState!.validate();
    }
  }
}
