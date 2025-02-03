part of 'wallet_cubit.dart';

sealed class WalletState {}

final class WalletInitial extends WalletState {}

final class LoadingGetWalletTransactionsAppState extends WalletState {}

final class SuccessGetWalletTransactionsAppState extends WalletState {}

final class ErrorGetWalletTransactionsAppState extends WalletState {
  final String error;

  ErrorGetWalletTransactionsAppState({required this.error});
}

class WalletUpdatedState extends WalletState {
  final List<WalletTransactions> transactions;

  WalletUpdatedState(this.transactions);
}

final class LoadingDepositToWalletAppState extends WalletState {}

final class SuccessDepositToWalletAppState extends WalletState {}

final class ErrorDepositToWalletAppState extends WalletState {
  final String error;

  ErrorDepositToWalletAppState({required this.error});
}

final class LoadingGetWalletBasketTransactionsAppState extends WalletState {}

final class SuccessGetWalletBasketTransactionsAppState extends WalletState {}

final class ErrorGetWalletBasketTransactionsAppState extends WalletState {
  final String error;

  ErrorGetWalletBasketTransactionsAppState({required this.error});
}

final class LoadingDeleteWalletBasketTransactionsAppState extends WalletState {}

final class SuccessDeleteWalletBasketTransactionsAppState extends WalletState {
  final List<WalletTransactions> transactions;

  SuccessDeleteWalletBasketTransactionsAppState(this.transactions);
}

final class ErrorDeleteWalletBasketTransactionsAppState extends WalletState {
  final String error;

  ErrorDeleteWalletBasketTransactionsAppState({required this.error});
}

final class LoadingGetLastBalanceAppState extends WalletState {}

final class SuccessGetLastBalanceAppState extends WalletState {}

final class ErrorGetLastBalanceAppState extends WalletState {
  final String error;

  ErrorGetLastBalanceAppState({required this.error});
}
