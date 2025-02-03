import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_share/business_logic/auth/auth_cubit.dart';
import 'package:ride_share/business_logic/home/home_cubit.dart';
import 'package:ride_share/business_logic/trips/trips_cubit.dart';
import 'package:ride_share/business_logic/wallet/wallet_cubit.dart';
import 'package:ride_share/core/di/di.dart';
import 'package:ride_share/core/routing/app_router.dart';
import 'package:ride_share/core/routing/routes.dart';
import 'package:ride_share/core/shared/bloc_observer/bloc_observer.dart';
import 'package:ride_share/core/shared/location_helper/location_helper.dart';
import 'package:ride_share/core/shared/notification_helper/notification_helper.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences_keys.dart';
import 'package:ride_share/core/themes/colors.dart';

import 'firebase_options.dart';

void main() async {
  setupServiceLocator();
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FCMNotificationService().init();
  await LocationHelper.getCurrentAddress();
  await SharedPreferencesService.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: ColorsManager.mainColor),
  );
  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key, required this.appRouter});

  AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<AuthCubit>()),
          BlocProvider(
              create: (context) => getIt<HomeCubit>()
                ..getAdminMessages()
                ..getUserProfileData()
                ..getUserBalance()),
          BlocProvider(
              create: (context) =>
                  getIt<WalletCubit>()..getAllWalletTransactions()),
          BlocProvider(create: (context) => getIt<TripsCubit>()..getAllTrips()),
        ],
        child: MaterialApp(
          title: 'Ride Share',
          localizationsDelegates: const [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale(
              "ar",
            ),
          ],
          locale: const Locale(
            "ar",
          ),
          theme: ThemeData(
            scaffoldBackgroundColor: ColorsManager.white,
            appBarTheme: const AppBarTheme(
              color: ColorsManager.secondaryColor,
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: ColorsManager.mainColor,
            ),
            useMaterial3: true,
          ),
          initialRoute: getStart(),
          onGenerateRoute: appRouter.generateRoute,
        ),
      ),
    );
  }

  String getStart() {
    final route = SharedPreferencesService.getData(
                key: SharedPreferencesKeys.startScreen) ==
            null
        ? Routes.startScreen
        : SharedPreferencesService.getData(
                    key: SharedPreferencesKeys.userToken) ==
                null
            ? Routes.loginScreen
            : Routes.homeScreen;

    return route;
  }
}
