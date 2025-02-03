import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_share/data/models/home/wallet/get_wallet_transactions.dart';
import 'package:ride_share/data/models/home/wallet/user_balance.dart';
import 'package:ride_share/data/remote_data_source/wallet_remote_data_source/wallet_remote_data_source.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletRemoteDataSource walletRemoteDataSource;

  WalletCubit(this.walletRemoteDataSource) : super(WalletInitial());

  var amountValueController = TextEditingController();
  List<WalletTransactions> transactions = [];
  GetAllWalletTransactions? getAllWalletTransactionsModel;

  Future<void> getAllWalletTransactions() async {
    emit(LoadingGetWalletTransactionsAppState());

    try {
      final response = await walletRemoteDataSource.getWalletTransactions();

      getAllWalletTransactionsModel =
          GetAllWalletTransactions.fromJson(response.data);
      transactions.clear();
      transactions.addAll(getAllWalletTransactionsModel!.body!);

      emit(SuccessGetWalletTransactionsAppState());
    } catch (error) {
      print(error);
      emit(ErrorGetWalletTransactionsAppState(error: error.toString()));
    }
  }

  Future<void> depositToWallet() async {
    emit(LoadingDepositToWalletAppState());

    try {
      await walletRemoteDataSource.depositToWallet(
        initialAmount: double.parse(amountValueController.text),
      );
      emit(SuccessDepositToWalletAppState());
    } catch (error) {
      print(error);
      emit(ErrorDepositToWalletAppState(error: error.toString()));
    }
  }

  GetAllWalletTransactions? getWalletBasketTransactionsModel;
  List<WalletTransactions> basketTransactions = [];

  Future<void> getWalletBasketTransactions() async {
    emit(LoadingGetWalletBasketTransactionsAppState());

    try {
      final response =
          await walletRemoteDataSource.getWalletBasketTransactions();

      getWalletBasketTransactionsModel =
          GetAllWalletTransactions.fromJson(response.data);

      basketTransactions.clear();
      basketTransactions.addAll(getWalletBasketTransactionsModel!.body!);

      print(basketTransactions);

      emit(SuccessGetWalletBasketTransactionsAppState());
    } catch (error) {
      print(error);
      emit(ErrorGetWalletBasketTransactionsAppState(error: error.toString()));
    }
  }

  Future<void> deleteWalletTransaction({required int id}) async {
    emit(LoadingDeleteWalletBasketTransactionsAppState());
    try {
      await walletRemoteDataSource.deleteTransaction(id: id);
      basketTransactions.removeWhere((tx) => tx.id == id);

      emit(SuccessDeleteWalletBasketTransactionsAppState(basketTransactions));
    } catch (error) {
      print(error);
      emit(
          ErrorDeleteWalletBasketTransactionsAppState(error: error.toString()));
    }
  }

  GetUserBalance? getUserBalanceModel;

  Future<void> getUserBalance() async {
    emit(LoadingGetLastBalanceAppState());

    try {
      final response = await walletRemoteDataSource.getLastBalance();

      getUserBalanceModel = GetUserBalance.fromJson(response.data);

      emit(SuccessGetLastBalanceAppState());
    } catch (error) {
      print(error);
      emit(ErrorGetLastBalanceAppState(error: error.toString()));
    }
  }
}
