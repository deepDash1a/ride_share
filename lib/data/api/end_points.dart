class EndPoints {
  // base url end point
  static const String baseUrl = 'https://ride-share.commuterscarpoling.net/api';
  static const String imagesBaseUrl =
      'https://ride-share.commuterscarpoling.net/storage/';

  // auth
  static const String login = '/login';
  static const String fcmToken = '/fcm-token';
  static const String forgetPassword = '/forgot-password';
  static const String register = '/register';

  // home
  static const String getUserProfileData = '/profile/';
  static const String updateUserProfileData = '/profile/update';
  static const String getAdminMessages = '/messages/';

  static String updateAdminMessages(int messageId) {
    return '/messages/$messageId';
  }

// trips
  static const String createNewIndividualTrip = '/trips/store';
  static const String createNewGroupTrip = '/trips/store';
  static const String getTrips = '/trips';
  static const String getPendingTrips = '/trips/pending';
  static const String getApprovedTrips = '/trips/approved';
  static const String getInProgressTrips = '/trips/in-progress';
  static const String getCompletedTrips = '/trips/completed';
  static const String getRejectedTrips = '/trips/rejected';
  static const String getCanceledTrips = '/trips/canceled';

  static String updateTripCanceled({required int id}) {
    return '/trips/canceled/$id';
  }

  // feed back
  static const String storeFeedBack = '/feedback/store';

  // chat
  static const String conversation = '/conversation/';
  static const String storeConversation = '/conversation/store';

  static String getCustomConversation({required int id}) {
    return '/conversation/$id';
  }

  // location
  static const String savedLocation = '/saved-location';
  static const String getLocation = '/saved-location';

// wallet
  static const String getAllWalletTransactions = '/wallets/';
  static const String getWalletBasketTransactions = '/wallets/basket';
  static const String depositToWallet = '/wallets/store';

  static String depositWalletTransaction({required int id}) {
    return '/kashier/payment/$id';
  }

  static String deleteWalletTransaction({required int id}) {
    return '/wallets/$id';
  }

  static const String getLastBalance = '/wallets/last-balance';
}
