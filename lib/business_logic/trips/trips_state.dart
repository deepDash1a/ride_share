part of 'trips_cubit.dart';

sealed class TripsState {}

final class TripsInitial extends TripsState {}

final class RefreshScreenAppState extends TripsState {}

class PlacesLoadedTrip extends TripsState {
  final List<dynamic> placesSuggestion;

  PlacesLoadedTrip(this.placesSuggestion);
}

class PlaceDetailsLoadedTrip extends TripsState {
  final Place placeLocation;

  PlaceDetailsLoadedTrip(this.placeLocation);
}

final class LoadingCreateNewGroupTripAppState extends TripsState {}

final class SuccessCreateNewGroupTripAppState extends TripsState {}

final class ErrorCreateNewGroupTripAppState extends TripsState {
  final String error;

  ErrorCreateNewGroupTripAppState({required this.error});
}

final class LoadingCreateNewIndividualTripAppState extends TripsState {}

final class SuccessCreateNewIndividualTripAppState extends TripsState {}

final class ErrorCreateNewIndividualTripAppState extends TripsState {
  final String error;

  ErrorCreateNewIndividualTripAppState({required this.error});
}

final class LoadingGetAllTripsAppState extends TripsState {}

final class SuccessGetAllTripsAppState extends TripsState {}

final class ErrorGetAllTripsAppState extends TripsState {
  final String error;

  ErrorGetAllTripsAppState({required this.error});
}

final class ChangeChildrenAppState extends TripsState {}

// trips status
final class RefreshState extends TripsState {}

final class ChangeTripsState extends TripsState {}

final class SelectDateOfMonthlyTripsState extends TripsState {}

final class SelectTimeOfMonthlyTripsState extends TripsState {}

final class LoadingGetPendingTripsAppState extends TripsState {}

final class SuccessGetPendingTripsAppState extends TripsState {}

final class ErrorGetPendingTripsAppState extends TripsState {}

final class LoadingGetApprovedTripsAppState extends TripsState {}

final class SuccessGetApprovedTripsAppState extends TripsState {}

final class ErrorGetApprovedTripsAppState extends TripsState {}

final class LoadingGetInProgressTripsAppState extends TripsState {}

final class SuccessGetInProgressTripsAppState extends TripsState {}

final class ErrorGetInProgressTripsAppState extends TripsState {}

final class LoadingGetCompletedTripsAppState extends TripsState {}

final class SuccessGetCompletedTripsAppState extends TripsState {}

final class ErrorGetCompletedTripsAppState extends TripsState {}

final class LoadingGetRejectedTripsAppState extends TripsState {}

final class SuccessGetRejectedTripsAppState extends TripsState {}

final class ErrorGetRejectedTripsAppState extends TripsState {}

final class LoadingGetCanceledTripsAppState extends TripsState {}

final class SuccessGetCanceledTripsAppState extends TripsState {}

final class ErrorGetCanceledTripsAppState extends TripsState {}

final class LoadingSaveTripFeedBackAppState extends TripsState {}

final class SuccessSaveTripFeedBackAppState extends TripsState {}

final class ErrorSaveTripFeedBackAppState extends TripsState {
  final String error;

  ErrorSaveTripFeedBackAppState({required this.error});
}

final class LoadingGetConversationAppState extends TripsState {}

final class SuccessGetConversationAppState extends TripsState {}

final class ErrorGetConversationAppState extends TripsState {
  final String error;

  ErrorGetConversationAppState({required this.error});
}

final class LoadingGetCustomConversationAppState extends TripsState {}

final class SuccessGetCustomConversationAppState extends TripsState {}

final class ErrorGetCustomConversationAppState extends TripsState {
  final String error;

  ErrorGetCustomConversationAppState({required this.error});
}

final class LoadingStoreConversationAppState extends TripsState {}

final class SuccessStoreConversationAppState extends TripsState {}

final class ErrorStoreConversationAppState extends TripsState {
  final String error;

  ErrorStoreConversationAppState({required this.error});
}

final class LoadingUpdateCanceledTripAppState extends TripsState {}

final class SuccessUpdateCanceledTripAppState extends TripsState {}

final class ErrorUpdateCanceledTripAppState extends TripsState {
  final String error;

  ErrorUpdateCanceledTripAppState({required this.error});
}

final class LoadingChatTripAppState extends TripsState {}

final class SuccessChatTripAppState extends TripsState {}

final class ErrorChatTripAppState extends TripsState {
  final String error;

  ErrorChatTripAppState({required this.error});
}
