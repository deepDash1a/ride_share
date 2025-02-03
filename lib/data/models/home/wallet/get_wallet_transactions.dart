import 'package:equatable/equatable.dart';
import 'package:ride_share/core/shared/shared_models/base_response_model.dart';

class GetAllWalletTransactions
    extends BaseResponseModel<List<WalletTransactions>> {
  const GetAllWalletTransactions({
    required super.status,
    required super.message,
    super.body,
  });

  factory GetAllWalletTransactions.fromJson(Map<String, dynamic> json) {
    return GetAllWalletTransactions(
      status: json['status'],
      message: json['message'],
      body: List<WalletTransactions>.from(
          json['data'].map((e) => WalletTransactions.fromJson(e))).toList(),
    );
  }
}

// ignore: must_be_immutable
class WalletTransactions extends Equatable {
  int? id;
  int? userId;
  int? balance;
  String? operationType;
  int? transactionAmount;
  String? reason;
  int? initialAmount;
  String? status;
  String? createdAt;
  String? updatedAt;

  WalletTransactions({
    this.id,
    this.userId,
    this.balance,
    this.operationType,
    this.transactionAmount,
    this.reason,
    this.initialAmount,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  WalletTransactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    balance = json['balance'];
    operationType = json['operation_type'];
    transactionAmount = json['transaction_amount'];
    reason = json['reason'];
    initialAmount = json['initial_amount'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['balance'] = balance;
    data['operation_type'] = operationType;
    data['transaction_amount'] = transactionAmount;
    data['reason'] = reason;
    data['initial_amount'] = initialAmount;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        balance,
        operationType,
        transactionAmount,
        reason,
        initialAmount,
        status,
        createdAt,
        updatedAt,
      ];
}
