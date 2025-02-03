import 'package:get_it/get_it.dart';
import 'package:ride_share/business_logic/auth/auth_cubit.dart';
import 'package:ride_share/business_logic/home/home_cubit.dart';
import 'package:ride_share/business_logic/trips/trips_cubit.dart';
import 'package:ride_share/business_logic/wallet/wallet_cubit.dart';
import 'package:ride_share/data/api/dio_helper.dart';
import 'package:ride_share/data/remote_data_source/auth_remote_data_source/auth_remote_data_source.dart';
import 'package:ride_share/data/remote_data_source/home_remote_data_source/home_remote_data_source.dart';
import 'package:ride_share/data/remote_data_source/trips_remote_data_source/trips_remote_data_source.dart';
import 'package:ride_share/data/remote_data_source/wallet_remote_data_source/wallet_remote_data_source.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // Register DioHelper
  DioHelper.init();
  getIt.registerLazySingleton<DioHelper>(() => DioHelper());

  // Register AuthRemoteDataSource with DioHelper dependency
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(
        getIt<DioHelper>(),
      ));

  // Register AuthCubit with AuthRemoteDataSource dependency
  getIt.registerFactory<AuthCubit>(
      () => AuthCubit(getIt<AuthRemoteDataSource>()));

  // Register HomeRemoteDataSource with DioHelper dependency
  getIt.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSource(
        getIt<DioHelper>(),
      ));

  // Register HomeCubit with HomeRemoteDataSource dependency
  getIt.registerFactory<HomeCubit>(
      () => HomeCubit(getIt<HomeRemoteDataSource>()));

  // Register WalletRemoteDataSource with DioHelper dependency
  getIt.registerLazySingleton<WalletRemoteDataSource>(
      () => WalletRemoteDataSource(
            getIt<DioHelper>(),
          ));

  // Register WalletCubit with WalletRemoteDataSource dependency
  getIt.registerFactory<WalletCubit>(
      () => WalletCubit(getIt<WalletRemoteDataSource>()));

  // Register TripsRemoteDataSource with DioHelper dependency
  getIt.registerLazySingleton<TripsRemoteDataSource>(
      () => TripsRemoteDataSource(getIt<DioHelper>()));

  // Register TripsCubit with TripsRemoteDataSource dependency
  getIt.registerFactory<TripsCubit>(
      () => TripsCubit(getIt<TripsRemoteDataSource>()));
}
