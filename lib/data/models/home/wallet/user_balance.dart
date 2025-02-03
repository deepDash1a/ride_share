import 'package:equatable/equatable.dart';
import 'package:ride_share/core/shared/shared_models/base_response_model.dart';

class GetUserBalance extends BaseResponseModel<Data> {
  const GetUserBalance(
      {required super.status, required super.message, super.body});

  factory GetUserBalance.fromJson(Map<String, dynamic> json) {
    return GetUserBalance(
      status: json['status'],
      message: json['message'],
      body: Data.fromJson(json['data']),
    );
  }
}

// ignore:must_be_immutable
class Data {
  int? userId;
  int? lastBalance;

  Data({this.userId, this.lastBalance});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    lastBalance = json['last_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['last_balance'] = this.lastBalance;
    return data;
  }
}
