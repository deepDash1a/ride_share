part of 'home_cubit.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class ChangeVisibilityTrueOrFalseAppState extends HomeState {}

final class UploadImageState extends HomeState {}

class PlacesLoadedHome extends HomeState {
  final List<dynamic> placesSuggestion;

  PlacesLoadedHome(this.placesSuggestion);
}

class PlaceDetailsLoadedHome extends HomeState {
  final Place placeLocation;

  PlaceDetailsLoadedHome(this.placeLocation);
}

final class LoadingAdminMessagesAppState extends HomeState {}

final class SuccessAdminMessagesAppState extends HomeState {}

final class ErrorAdminMessagesAppState extends HomeState {
  final String error;

  ErrorAdminMessagesAppState({required this.error});
}

final class LoadingUpdateAdminMessagesAppState extends HomeState {}

final class SuccessUpdateAdminMessagesAppState extends HomeState {}

final class ErrorUpdateAdminMessagesAppState extends HomeState {
  final String error;

  ErrorUpdateAdminMessagesAppState({required this.error});
}

final class LoadingGetUserProfileAppState extends HomeState {}

final class SuccessGetUserProfileAppState extends HomeState {}

final class ErrorGetUserProfileAppState extends HomeState {
  final String error;

  ErrorGetUserProfileAppState({required this.error});
}

final class LoadingUpdateUserProfileAppState extends HomeState {}

final class SuccessUpdateUserProfileAppState extends HomeState {}

final class ErrorUpdateUserProfileAppState extends HomeState {
  final String error;

  ErrorUpdateUserProfileAppState({required this.error});
}

final class LoadingSaveLocationAppState extends HomeState {}

final class SuccessSaveLocationAppState extends HomeState {}

final class ErrorSaveLocationAppState extends HomeState {
  final String error;

  ErrorSaveLocationAppState({required this.error});
}

final class LoadingGetLocationAppState extends HomeState {}

final class SuccessGetLocationAppState extends HomeState {}

final class ErrorGetLocationAppState extends HomeState {
  final String error;

  ErrorGetLocationAppState({required this.error});
}

final class LoadingGetLastBalanceAppState extends HomeState {}

final class SuccessGetLastBalanceAppState extends HomeState {}

final class ErrorGetLastBalanceAppState extends HomeState {
  final String error;

  ErrorGetLastBalanceAppState({required this.error});
}
