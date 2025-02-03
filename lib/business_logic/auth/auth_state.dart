part of 'auth_cubit.dart';

  sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class ChangeVisibilityTrueOrFalseAppState extends AuthState {}

final class UploadImageState extends AuthState {}

class PlacesLoadedAuth extends AuthState {
  final List<dynamic> placesSuggestion;

  PlacesLoadedAuth(this.placesSuggestion);
}

class PlaceDetailsLoadedAuth extends AuthState {
  final Place placeLocation;

  PlaceDetailsLoadedAuth(this.placeLocation);
}

final class LoadingRegisterSearchMapAppState extends AuthState {}

final class SuccessRegisterSearchMapAppState extends AuthState {}

final class ErrorRegisterSearchMapAppState extends AuthState {
  final String error;

  ErrorRegisterSearchMapAppState({required this.error});
}

final class LoadingLoginAppState extends AuthState {}

final class SuccessLoginAppState extends AuthState {
  final GeneralUserModel generalUserModel;

  SuccessLoginAppState({required this.generalUserModel});
}

final class ErrorLoginAppState extends AuthState {
  final String error;

  ErrorLoginAppState({required this.error});
}

final class LoadingRegisterAppState extends AuthState {}

final class SuccessRegisterAppState extends AuthState {}

final class ErrorRegisterAppState extends AuthState {
  final String error;

  ErrorRegisterAppState({required this.error});
}

final class LoadingFcmTokenAppState extends AuthState {}

final class SuccessFcmTokenAppState extends AuthState {}

final class ErrorFcmTokenAppState extends AuthState {
  final String error;

  ErrorFcmTokenAppState({required this.error});
}
final class LoadingForgetPasswordAppState extends AuthState {}

final class SuccessForgetPasswordAppState extends AuthState {}

final class ErrorForgetPasswordAppState extends AuthState {
  final String error;

  ErrorForgetPasswordAppState({required this.error});
}
