import 'package:dio/dio.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences_keys.dart';
import 'package:ride_share/data/api/dio_helper.dart';
import 'package:ride_share/data/api/end_points.dart';

class WalletRemoteDataSource {
  final DioHelper dioHelper;

  WalletRemoteDataSource(this.dioHelper);

  getWalletTransactions() async {
    try {
      final response = await dioHelper.getData(
        url: EndPoints.getAllWalletTransactions,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  depositToWallet({required double initialAmount}) async {
    try {
      var data = {
        "user_id": await SharedPreferencesService.getData(
          key: SharedPreferencesKeys.userId,
        ),
        "initial_amount": initialAmount,
      };

      final response = await dioHelper.postData(
        url: EndPoints.depositToWallet,
        data: data,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  getWalletBasketTransactions() async {
    try {
      final response = await dioHelper.getData(
        url: EndPoints.getWalletBasketTransactions,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  deleteTransaction({required int id}) async {
    try {
      final response = await dioHelper.deleteData(
        url: EndPoints.deleteWalletTransaction(id: id),
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getLastBalance() async {
    try {
      final response = await dioHelper.getData(
        url: EndPoints.getLastBalance,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
