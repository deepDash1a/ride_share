import 'package:flutter/material.dart';
import 'package:ride_share/core/routing/routes.dart';
import 'package:ride_share/presentation/auth/login/screens/login.dart';
import 'package:ride_share/presentation/auth/register/screens/main_register.dart';
import 'package:ride_share/presentation/auth/register/screens/register.dart';
import 'package:ride_share/presentation/auth/register/screens/register_map.dart';
import 'package:ride_share/presentation/home/screen/home.dart';
import 'package:ride_share/presentation/home/widgets/chat/chat_trips.dart';
import 'package:ride_share/presentation/home/widgets/chat/chat_with_admins.dart';
import 'package:ride_share/presentation/home/widgets/feed_back/feed_back.dart';
import 'package:ride_share/presentation/home/widgets/locations/get_locations/get_location.dart';
import 'package:ride_share/presentation/home/widgets/locations/locations.dart';
import 'package:ride_share/presentation/home/widgets/locations/set_location/set_location.dart';
import 'package:ride_share/presentation/home/widgets/profile/profile.dart';
import 'package:ride_share/presentation/home/widgets/profile/update_profile.dart';
import 'package:ride_share/presentation/home/widgets/trips/screen/individual_or_group.dart';
import 'package:ride_share/presentation/home/widgets/trips/screen/trips.dart';
import 'package:ride_share/presentation/home/widgets/trips/widgets/group/main_group_trip.dart';
import 'package:ride_share/presentation/home/widgets/trips/widgets/individual/main_individual_trip.dart';
import 'package:ride_share/presentation/home/widgets/trips/widgets/trip_details/trip_details.dart';
import 'package:ride_share/presentation/home/widgets/wallet/screen/wallet.dart';
import 'package:ride_share/presentation/home/widgets/wallet/widgets/payment_basket.dart';
import 'package:ride_share/presentation/start/screens/start_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      // start screen
      case Routes.startScreen:
        return MaterialPageRoute(builder: (context) => const StartScreen());

      // auth screens
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case Routes.mainRegister:
        return MaterialPageRoute(builder: (context) => const MainRegister());
      case Routes.registerScreen:
        return MaterialPageRoute(builder: (context) => const RegisterScreen());
      case Routes.registerMap:
        return MaterialPageRoute(builder: (context) => const RegisterMap());

      // home
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (context) => HomeScreen());

      // home => wallet
      case Routes.walletScreen:
        return MaterialPageRoute(builder: (context) => const WalletScreen());
      case Routes.walletBasketScreen:
        return MaterialPageRoute(builder: (context) => const PaymentBasket());

      // home => profile
      case Routes.profileScreen:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());
      case Routes.updateProfileScreen:
        return MaterialPageRoute(builder: (context) => const UpdateProfile());

      // home => trips
      case Routes.tripsScreen:
        return MaterialPageRoute(builder: (context) => const TripsScreen());
      case Routes.individualOrGroupScreen:
        return MaterialPageRoute(
            builder: (context) => const IndividualOrGroupScreen());

      case Routes.groupTrip:
        return MaterialPageRoute(builder: (context) => const MainGroupTrip());

      case Routes.individualTrip:
        return MaterialPageRoute(
            builder: (context) => const MainIndividualTrip());

      case Routes.tripDetails:
        return MaterialPageRoute(builder: (context) => const TripDetails());

      // home => feed back
      case Routes.feedBackTrip:
        return MaterialPageRoute(builder: (context) => const TripsFeedBack());
      // home => chat
      case Routes.chatTrip:
        return MaterialPageRoute(builder: (context) => const ChatTrips());
      case Routes.chatWithAdminTrip:
        return MaterialPageRoute(builder: (context) => const ChatWithAdmins());

      // home => locations
      case Routes.locationsScreen:
        return MaterialPageRoute(builder: (context) => const Locations());
      case Routes.setLocationScreen:
        return MaterialPageRoute(builder: (context) => const SetLocation());
      case Routes.getLocationScreen:
        return MaterialPageRoute(builder: (context) => const GetLocation());
    }
    return null;
  }
}
